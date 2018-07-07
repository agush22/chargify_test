class PaymentService
  include HTTParty
  base_uri 'http://localhost:4567'


  def initialize
    u = Rails.configuration.x.payment_api.user
    p = Rails.configuration.x.payment_api.password
    @auth = { username: u, password: p }
  end

  def charge(options = {})
    return {body: "Invalid CC", code: 406 } unless Luhn.valid?(options[:credit_card])
    max_retries = Rails.configuration.x.payment_api.retries
    options.merge!({ basic_auth: @auth })
    begin
      retries ||= 0
      raw_response = self.class.get('/validate', options)
      if raw_response.code != 200
        raise "Service response: #{raw_response.code}"
      end
    rescue
      return {body: "No response", code: 503 } if raw_response.nil?
      retry if (500..511).include?(raw_response.code) && (retries += 1) < max_retries
    end
    format_response(raw_response)
  end

  def format_response(raw_response)
    result = {}
    if raw_response.code == 200
      result[:body] = raw_response.parsed_response.symbolize_keys
      result[:body][:paid] ? result[:code] = 200 : result[:code] = 402
    else
      result[:code] = raw_response.code
      result[:body] = raw_response.parsed_response
    end
    result
  end
end
