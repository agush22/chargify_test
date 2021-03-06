require 'test_helper'

class PaymentServiceTest < ActiveSupport::TestCase
  describe PaymentService do

    before do
      valid_visa = 4111111111111111
      valid_mastercard = 5555555555554444
      @charge_options = {credit_card: valid_visa}
    end

    describe "default attributes" do
      it "must include httparty methods" do
        PaymentService.must_include HTTParty
      end
      it "must have a base_uri" do
        PaymentService.base_uri.must_equal 'http://localhost:4567'
      end
    end

    describe "Success" do
      before do
        VCR.insert_cassette 'payment_success'
      end
      after do
        VCR.eject_cassette
      end

      it "returns a succesful payment" do
        paid = {:body=>{:id=>"2e225be0b33a2b01", :paid=>true, :failure_message=>nil}, :code=>200}
        PaymentService.new.charge(@charge_options).must_equal paid

      end
    end

    describe "Invalid" do
      it "returns a succesful payment" do
        invalid = {:body=>"Invalid CC", :code=>406}
        PaymentService.new.charge({credit_card: 8273123273520569}).must_equal invalid
      end
    end

    describe "Declined" do
      before do
        VCR.insert_cassette 'payment_declined'
      end
      after do
        VCR.eject_cassette
      end

      it "returns insufficient funds" do
        declined = {:body=>{:id=>"487db7e8e59d8a44", :paid=>false, :failure_message=>"insufficient_funds"}, :code=>402}
        PaymentService.new.charge(@charge_options).must_equal declined
      end
    end

    describe "Time out" do
      before do
        VCR.insert_cassette 'payment_timeout'
      end

      after do
        VCR.eject_cassette
      end

      it "returns 503 response" do
        timeout = {:code=>503, :body=>"Service Unavailable"}
        PaymentService.new.charge(@charge_options).must_equal timeout
      end
    end

    describe "Unauthorized" do
      before do
        VCR.insert_cassette 'payment_unauthorized'
      end

      after do
        VCR.eject_cassette
      end

      it "returns unauthorized response" do
        unauthorized = {:code=>401, :body=>"Not authorized"}
        PaymentService.new.charge(@charge_options).must_equal unauthorized
      end
    end

  end
end
