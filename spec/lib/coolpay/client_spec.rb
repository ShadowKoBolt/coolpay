require 'spec_helper'

RSpec.describe Coolpay::Client do
  describe '#recipients' do
    subject(:call) do
      described_class.new(username: username, api_key: api_key, coolpay_url: coolpay_url).recipients(name: name)
    end

    let(:username) { 'username' }
    let(:api_key) { 'api_key' }
    let(:coolpay_url) { 'https://foo.bar' }

    let(:authenticating_client) { instance_double(Coolpay::AuthenticatingClient) }

    before do
      allow(Coolpay::AuthenticatingClient)
        .to receive(:new)
        .with(username: username, api_key: api_key, authenticate_url: 'https://foo.bar/login')
        .and_return(authenticating_client)
    end

    context 'with no name' do
      let(:name) { nil }

      before do
        allow(authenticating_client)
          .to receive(:get)
          .with('https://foo.bar/recipients', params: { name: nil })
          .and_return('recipients' => %w[a b])
      end

      it { is_expected.to eq(%w[a b]) }
    end

    context 'with a name' do
      let(:name) { 'foo' }

      before do
        allow(authenticating_client)
          .to receive(:get)
          .with('https://foo.bar/recipients', params: { name: 'foo' })
          .and_return('recipients' => %w[a b])
      end

      it { is_expected.to eq(%w[a b]) }
    end
  end

  describe '#create_recipient' do
    subject(:call) do
      described_class.new(username: username, api_key: api_key, coolpay_url: coolpay_url).create_recipient(name: name)
    end

    context 'with a valid name' do
      let(:name) { 'Jon Snow' }

    end

    context 'with an invalid name' do
    end
  end
end
