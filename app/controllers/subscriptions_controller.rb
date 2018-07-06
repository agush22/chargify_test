class SubscriptionsController < ApplicationController

  def index
    @subscriptions = Subscription.all
    render json: @subscriptions
  end

  def create
    if payment[:code] == 200
      @subscription = Subscription.new(payment_id: payment[:body][:id])
      if @subscription.save
        render json: @subscription, status: :created, location: @subscription
      else
        render json: @subscription.errors, status: :unprocessable_entity
      end
    else
      render json: payment[:body], status: payment[:code]
    end
  end

  def payment
    @payment ||= PaymentService.new.charge
  end

end
