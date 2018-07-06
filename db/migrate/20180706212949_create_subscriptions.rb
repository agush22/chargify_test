class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.string :payment_id
      t.string :customer_name
      t.date :next_billing_date
      t.timestamps
    end
  end
end

