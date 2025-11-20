# frozen_string_literal: true

require 'spec_helper'

describe 'Fail2ban::IP' do
  [
    'example.com',
    '172.16.0.0/12',
    '172.16.0.1',
    'fd07:e689:f0d2:5ca9::/64',
    'fd07:e689:f0d2:5ca9:0000:0000:0000:0000',
  ].each do |allowed_value|
    it { is_expected.to allow_value(allowed_value) }
  end

  [
    'fd07:e689:f0d2:5ca9:zzzz:zzzz:gggg:gggg',
    'example:com'
  ].each do |invalid_value|
    it { is_expected.not_to allow_value(invalid_value) }
  end
end
