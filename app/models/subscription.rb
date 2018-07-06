class Subscription < ApplicationRecord
  before_create do
    self.next_billing_date = Date.today.next_month
  end
end
