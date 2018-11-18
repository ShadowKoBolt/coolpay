module Coolpay
  # Handle typhoeus success and error responses
  class ResponseParser
    class << self
      def call(args)
        new(args).call
      end
    end

    def initialize(response)
      @response = response
    end

    def call
      case response.code
      when 200, 201
        JSON.parse(response.body)
      when 401
        raise Unauthorized
      when 404
        raise NotFound
      when 422
        raise UnprocessableEntity, response.body
      else
        raise UnknownStatus
      end
    end

    private

    attr_reader :response

    class Unauthorized < StandardError; end
    class NotFound < StandardError; end
    class UnknownStatus < StandardError; end
    class UnprocessableEntity < StandardError; end
  end
end
