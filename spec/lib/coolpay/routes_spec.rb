require 'spec_helper'

RSpec.describe Coolpay::Routes do
  describe '#authenicate_url' do
    subject { described_class.new(url: 'https://coolpay.herokuapp.com/api').authenticate_url }

    it { is_expected.to eq('https://coolpay.herokuapp.com/api/login') }
  end

  describe '#recipients_url' do
    subject { described_class.new(url: 'https://coolpay.herokuapp.com/api').recipients_url }

    it { is_expected.to eq('https://coolpay.herokuapp.com/api/recipients') }
  end

  describe '#payments_url' do
    subject { described_class.new(url: 'https://coolpay.herokuapp.com/api').payments_url }

    it { is_expected.to eq('https://coolpay.herokuapp.com/api/payments') }
  end
end
