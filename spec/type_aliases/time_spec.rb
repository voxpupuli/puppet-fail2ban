# frozen_string_literal: true

require 'spec_helper'

describe 'Fail2ban::Time' do
  [
    0,
    1252,
    '42h',
    '42h',
    '1w',
    '1y',
    '1d12h',
  ].each do |allowed_value|
    it { is_expected.to allow_value(allowed_value) }
  end

  [
    'mistake',
  ].each do |invalid_value|
    it { is_expected.not_to allow_value(invalid_value) }
  end
end
