require 'spec_helper'

describe 'fail2ban::jail' do
  let(:title) { 'spec_test_jail' }
  let(:pre_condition) { 'include fail2ban' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) do
        {
          'logpath'            => '/var/log/syslog',
          'filter_failregex'   => 'Login failed for user .* from <HOST>',
          'filter_maxlines'    => 10,
          'filter_datepattern' => '%%Y-%%m-%%d %%H:%%M(?::%%S)?'
        }
      end

      it do
        is_expected.to compile.with_all_deps
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

      it do
        is_expected.to contain_file('custom_filter_spec_test_jail').with(
          'ensure'  => 'file',
          'notify'  => 'Service[fail2ban]',
          'content' => %r{maxlines = 10}
        )
      end

      it do
        is_expected.to contain_file('custom_filter_spec_test_jail').with(
          'ensure'  => 'file',
          'notify'  => 'Service[fail2ban]',
          'content' => %r{datepattern = %%Y-%%m-%%d %%H:%%M(?::%%S)?}
        )
      end
    end
  end
end
