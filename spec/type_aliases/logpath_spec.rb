# frozen_string_literal: true

require 'spec_helper'

describe 'Fail2ban::Logpath' do
  [
    '/var/log/file.log',
    '/var/log/file.log[1-9]',
    ['/var/log/file.log', '/var/log/file.log.1'],
  ].each do |allowed_value|
    it { is_expected.to allow_value(allowed_value) }
  end
end
