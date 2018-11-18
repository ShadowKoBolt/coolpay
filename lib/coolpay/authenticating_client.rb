module Coolpay
  # Client for making authenticated calls
  class AuthenticatingClient
    def initialize(username:, api_key:, authenticate_url:)
      @username = username
      @api_key = api_key
      @authenticate_url = authenticate_url
    end

    def get(url, options = {})
      retries ||= 0
      response = Typhoeus.get(url, options.merge(headers: authenticated_header))
      ResponseParser.call(response)
    rescue ResponseParser::Unauthorized => exception
      @token = nil
      retry if (retries += 1) < 2
      raise exception
    end

    def post(url, options = {})
      retries ||= 0
      response = Typhoeus.post(url, options.merge(headers: authenticated_header))
      ResponseParser.call(response)
    rescue ResponseParser::Unauthorized => exception
      @token = nil
      retry if (retries += 1) < 2
      raise exception
    end

    private

    attr_reader :username, :api_key, :authenticate_url

    def default_header
      { 'Content-Type' => 'application/json' }
    end

    def authenticated_header
      default_header.merge('Authorization' => "Bearer #{token}")
    end

    def token
      @token ||= authenticate['token']
    end

    def authenticate
      response = Typhoeus.post(
        authenticate_url,
        headers: default_header,
        params: { username: username, apikey: api_key }
      )
      ResponseParser.call(response)
    rescue ResponseParser::Unauthorized
      raise AuthenticateFailed
    end

    class AuthenticateFailed < StandardError; end
  end
end
