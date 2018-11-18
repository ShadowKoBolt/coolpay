# Coolpay

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/coolpay`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coolpay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coolpay

## Usage


### Client instance

Create an instance of a `Coolpay::Client` to access the API e.g.

```ruby
client = Coolpay::Client.new(username: "foo", api_key: "bar")
```

You can also supply a `coolpay_url` named param if you need to hit an alternative base coolpay API URL.

A client will automatically authenticate when you make a request.  If the token is rejected on a subsiquent request it
will be automatically regenerated and the request will be retried.

### Getting recipients

```ruby
client.recipients
=> [{"name"=>"Jon Snow", "id"=>"8c9082cf-f9f5-4c28-9816-2d1e836e2cb5"},
 {"name"=>"Ned Stark", "id"=>"916c730c-94ae-43ea-8f5c-0c2bb5e22b7d"},
 {"name"=>"Sansa Stark", "id"=>"fabe7ea6-4eed-4239-97a6-e4f24d763749"},
 {"name"=>"Robert Baratheon", "id"=>"cedfcf61-b9f0-4944-a597-c0ac6d3b3841"}]
```

### Creating a recipient

```ruby
client.create_recipient(name: "Tyrion Lannister")
=> {"name"=>"Tyrion Lannister", "id"=>"8f75060f-c26f-4188-b00b-fc11318a8db2"}
```

### Getting payments

```ruby
client.payments
=> [{"status"=>"paid",
  "recipient_id"=>"916c730c-94ae-43ea-8f5c-0c2bb5e22b7d",
  "id"=>"e073b4a4-afa5-4086-92ac-e3e9bc002575",
  "currency"=>"GBP",
  "amount"=>"3"},
 {"status"=>"failed",
  "recipient_id"=>"8c9082cf-f9f5-4c28-9816-2d1e836e2cb5",
  "id"=>"05f91f84-8c18-491f-8b8a-ae0e49e8c721",
  "currency"=>"GBP",
  "amount"=>"11"},
 {"status"=>"paid",
  "recipient_id"=>"cedfcf61-b9f0-4944-a597-c0ac6d3b3841",
  "id"=>"ec6e621a-de2f-4479-9e3e-b50c18c78420",
  "currency"=>"GBP",
  "amount"=>"54"}]
```

### Creating a payment
```ruby
client.create_payment(recipient_id: "916c730c-94ae-43ea-8f5c-0c2bb5e22b7d", currency: "GBP", amount: 10)
=> {"status"=>"processing",
 "recipient_id"=>"916c730c-94ae-43ea-8f5c-0c2bb5e22b7d",
 "id"=>"6ad059dc-9293-426a-a49a-b8f30809b56d",
 "currency"=>"GBP",
 "amount"=>"10"}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## TODO

* Objectify recipients and payments
* Add links between objects to allow calls like `client.recipients.first.payments` or `client.recipients.first.create_payment`
* Add error parsing to improve the representation of errors returned from the API
