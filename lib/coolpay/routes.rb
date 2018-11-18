module Coolpay
  # Class to determine what URLs to sent coolpay requests to
  class Routes
    def initialize(url:)
      @url = url
    end

    def authenticate_url
      path = File.join(base_path, 'login')
      URI::HTTPS.build(host: host, path: path).to_s
    end

    def recipients_url
      path = File.join(base_path, 'recipients')
      URI::HTTPS.build(host: host, path: path).to_s
    end

    def payments_url
      path = File.join(base_path, 'payments')
      URI::HTTPS.build(host: host, path: path).to_s
    end

    private

    attr_reader :url

    def host
      @host ||= uri.host
    end

    def base_path
      @base_path ||= uri.path
    end

    def uri
      @uri ||= URI.parse(url)
    end
  end
end
