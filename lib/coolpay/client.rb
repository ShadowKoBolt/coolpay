module Coolpay
  # Represents a connection to coolpay api, handling authentication and
  # refreshing token
  class Client
    def initialize(username:, api_key:, coolpay_url: 'https://coolpay.herokuapp.com/api')
      @username = username
      @api_key = api_key
      @coolpay_url = coolpay_url
    end

    def recipients(name: nil)
      params = name.present? ? { name: name } : nil
      authenticating_client.get(routes.recipients_url, params: params)['recipients']
    end

    def create_recipient(name:)
      authenticating_client.post(routes.recipients_url, params: { recipient: { name: name } })['recipient']
    end

    def payments
      authenticating_client.get(routes.payments_url)['payments']
    end

    def create_payment(recipient_id:, currency:, amount:)
      authenticating_client.post(
        routes.payments_url,
        params: { payment: { recipient_id: recipient_id, amount: amount, currency: currency } }
      )['payment']
    end

    private

    attr_reader :username, :api_key, :coolpay_url

    def routes
      @routes ||= Coolpay::Routes.new(url: coolpay_url)
    end

    def authenticating_client
      @authenticating_client ||= AuthenticatingClient.new(
        username: username,
        api_key: api_key,
        authenticate_url: routes.authenticate_url
      )
    end
  end
end
