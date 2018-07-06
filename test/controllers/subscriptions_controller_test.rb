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

  #test "should show subscription" do
   # get subscription_url(@subscription), as: :json
    #assert_response :success
  #end

end
