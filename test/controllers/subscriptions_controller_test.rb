require 'test_helper'

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subscription = subscriptions(:one)
  end

  test "should get index" do
    get subscriptions_url, as: :json
    assert_response :success
  end

  test "should create subscription" do

    VCR.insert_cassette 'payment_success'
    assert_difference('Subscription.count') do
      post subscriptions_url, params: { subscription: { customer_name: @subscription.customer_name } }, as: :json
    end

    VCR.eject_cassette

    assert_response 201
  end

  test "should not create subscription with insufficient funds" do
    VCR.insert_cassette 'payment_declined'
    post subscriptions_url, params: { subscription: { customer_name: @subscription.customer_name } }, as: :json
    VCR.eject_cassette

    assert_response 402

  end

  test "should not create subscription with wrong credentials" do
    VCR.insert_cassette 'payment_unauthorized'
    post subscriptions_url, params: { subscription: { customer_name: @subscription.customer_name } }, as: :json
    VCR.eject_cassette

    assert_response 401

  end

  test "should not create subscription when timeout" do
    VCR.insert_cassette 'payment_timeout'
    post subscriptions_url, params: { subscription: { customer_name: @subscription.customer_name } }, as: :json
    VCR.eject_cassette

    assert_response 503

  end


end
