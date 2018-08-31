require 'spec_helper'

describe 'fail2ban::jail' do
  let(:title) { 'spec_test_jail' }
  let(:pre_condition) { 'include fail2ban' }
  let(:facts) do
    {
      'os' => {
        'family'  => 'RedHat',
        'release' => {
          'major' => '7',
          'minor' => '1',
          'full'  => '7.1.1503'
        }
      }
    }
  end

  let(:params) do
    {
      'logpath'          => '/var/log/syslog',
      'filter_failregex' => 'Login failed for user .* from <HOST>'
    }
  end

  it do
    is_expected.to compile
  end

  it do
    is_expected.to contain_file('custom_jail_spec_test_jail').with(
      'ensure'  => 'file',
      'notify'  => 'Service[fail2ban]',
      'content' => %r{\[spec_test_jail\]}
    )
  end

  it do
    is_expected.to contain_file('custom_filter_spec_test_jail').with(
      'ensure'  => 'file',
      'notify'  => 'Service[fail2ban]',
      'content' => %r{failregex = Login failed for user .* from <HOST>}
    )
  end
end
