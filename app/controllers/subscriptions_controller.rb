class SubscriptionsController < ApplicationController

  def index
    @subscriptions = Subscription.all
    render json: @subscriptions
  end

  def create
    credit_card = params[:subscription][:credit_card]
    payment_response = payment(credit_card)
    if payment_response[:code] == 200
      @subscription = Subscription.new(subscription_params.merge(payment_id: payment_response[:body][:id]))
      if @subscription.save
        render json: @subscription, status: :created, location: @subscription
      else
        render json: @subscription.errors, status: :unprocessable_entity
      end
    else
      render json: payment_response[:body], status: payment_response[:code]
    end
  end

  def payment(credit_card)
    @payment ||= PaymentService.new.charge({credit_card: credit_card})
  end

  private
  def subscription_params
    params.require(:subscription).permit(:customer_name)
  end

end
