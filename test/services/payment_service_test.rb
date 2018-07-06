require 'test_helper'

class PaymentServiceTest < ActiveSupport::TestCase

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
        PaymentService.new.charge.must_equal paid

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
        PaymentService.new.charge.must_equal declined
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
        PaymentService.new.charge.must_equal timeout
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
        PaymentService.new.charge.must_equal unauthorized
      end
    end
end
