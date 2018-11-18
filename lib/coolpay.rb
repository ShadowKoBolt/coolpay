require 'typhoeus'
require 'json'
require 'coolpay/version'
require 'coolpay/authenticating_client'
require 'coolpay/client'
require 'coolpay/routes'
require 'coolpay/response_parser'

module Coolpay
  CURRENCIES = ['GBP'].freeze
end
