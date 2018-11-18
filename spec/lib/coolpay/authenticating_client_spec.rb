require 'spec_helper'

RSpec.describe Coolpay::AuthenticatingClient do
  describe '#get' do
    subject(:call) do
      described_class.new(username: username, api_key: api_key, authenticate_url: authenticate_url).get(url, options)
    end

    let(:username) { 'username' }
    let(:api_key) { 'api_key' }
    let(:url) { 'http://bar.foo' }
    let(:authenticate_url) { 'http://foo.bar' }
    let(:options) { { params: { "a": 1 } } }

    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:authenticated_headers) { { 'Content-Type' => 'application/json', 'Authorization' => 'Bearer abc123' } }
    let(:authentication_response) { instance_double(Typhoeus::Response, code: 200, body: { token: 'abc123' }.to_json) }
    let(:typhoeus_response) { instance_double(Typhoeus::Response, code: 200, body: { 'foo' => 'bar' }.to_json) }

    before do
      allow(Typhoeus)
        .to receive(:post)
        .with(authenticate_url, headers: headers, params: { username: username, apikey: api_key })
        .and_return(authentication_response)
      allow(Typhoeus)
        .to receive(:get)
        .with(url, options.merge(headers: authenticated_headers))
        .and_return(*typhoeus_response)
    end

    context 'with success response' do
      it { is_expected.to eq('foo' => 'bar') }
    end

    context 'with failed authentication call' do
      let(:authentication_response) { instance_double(Typhoeus::Response, code: 401) }

      it { expect { call }.to raise_error(Coolpay::AuthenticatingClient::AuthenticateFailed) }
    end

    context 'with one unauthorized response' do
      let(:typhoeus_response) { [unauthenticated_response, success_response] }
      let(:unauthenticated_response) { instance_double(Typhoeus::Response, code: 401) }
      let(:success_response) { instance_double(Typhoeus::Response, code: 200, body: { foo: 'bar' }.to_json) }

      it { is_expected.to eq('foo' => 'bar') }
    end

    context 'with multiple unauthorized responses' do
      let(:typhoeus_response) { [unauthenticated_response, unauthenticated_response] }
      let(:unauthenticated_response) { instance_double(Typhoeus::Response, code: 401) }

      it { expect { call }.to raise_error(Coolpay::ResponseParser::Unauthorized) }
    end
  end
end
