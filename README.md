# Chargify Assesment
### by Agustín Leñero

## Setup
* The payment gateway code was modified to run as a Sinatra classic, you can check the code [here](https://gist.github.com/agush22/40c56b45be382fb15d998a24f25d84b3)
* Start the payment gateway at: `localhost:4567`
* Run `bundle install`
* Run `rails db:setup`
* Run `rails s`
* With the server running you should be good to go
* As an extra you can configure the number of retries on `config/application.rb` (currently set to 10)
----
To run the test suite:
* Run `rails test`
* Or `bundle exec guard`


## Create new subscriptions
With the server running do a **POST** to /subscriptions
#### Using **curl**:

`curl -d '{"subscription": {"credit_card": 4111111111111111 ,"customer_name": "Agustin"}}' -H "Content-Type: application/json" -X POST http://localhost:3000/subscriptions`

note: you should change *localhost:3000* to the address where the Rails app is running

Without a valid credit card number the request won't work.

## List the subscriptions

With the server running do a **GET** to /subscriptions to get a all the subscriptions and their next billing date
#### Using **curl**

`curl -X get http://localhost:3000/subscriptions`

note: you should change *localhost:3000* to the address where the Rails app is running
