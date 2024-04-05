# frozen_string_literal: true

require 'spec_helper'

describe 'fail2ban::port' do
  it { is_expected.to run.with_params('ssh', '22').and_return('22') }
  it { is_expected.to run.with_params('ssh', 22).and_return('22') }
  it { is_expected.to run.with_params('ssh', '22,22000').and_return('22,22000') }
  it { is_expected.to run.with_params('ssh', %w[22 22001]).and_return('22,22001') }
  it { is_expected.to run.with_params(nil).and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('ssh', {}).and_raise_error(ArgumentError) }
end
