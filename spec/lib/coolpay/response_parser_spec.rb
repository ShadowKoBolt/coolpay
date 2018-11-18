require 'spec_helper'

RSpec.describe Coolpay::ResponseParser do
  describe '.call' do
    subject(:call) { described_class.call(response) }

    context 'with ok response' do
      let(:response) do
        instance_double(Typhoeus::Response, code: 200, body: { 'foo' => 'bar' }.to_json)
      end

      it { is_expected.to eq('foo' => 'bar') }
    end

    context 'with not found response' do
      let(:response) do
        instance_double(Typhoeus::Response, code: 404)
      end

      it { expect { call }.to raise_error(Coolpay::ResponseParser::NotFound) }
    end

    context 'with not found response' do
      let(:response) do
        instance_double(Typhoeus::Response, code: 0)
      end

      it { expect { call }.to raise_error(Coolpay::ResponseParser::UnknownStatus) }
    end
  end
end
