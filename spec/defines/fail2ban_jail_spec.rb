# frozen_string_literal: true

require 'spec_helper'

describe 'fail2ban::jail' do
  let(:title) { 'spec_test_jail' }
  let(:pre_condition) { 'include fail2ban' }
  let(:common_params) do
    {
      'logpath' => '/var/log/syslog',
      'filter_failregex' => 'Login failed for user .* from <HOST>',
      'filter_maxlines' => 10,
      'filter_datepattern' => '%%Y-%%m-%%d %%H:%%M(?::%%S)?'
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) { common_params }

      it do
        is_expected.to compile.with_all_deps
      end

      it do
        is_expected.to contain_file('custom_jail_spec_test_jail').with(
          'ensure' => 'file',
          'notify' => 'Service[fail2ban]',
          'content' => %r{\[spec_test_jail\]}
        )
      end

      context 'with jail using several files in logpath' do
        let(:params) do
          common_params.merge(
            'logpath' => ['/var/log/syslog', '/var/log/syslog.1']
          )
        end

        it do
          is_expected.to contain_file('custom_jail_spec_test_jail').with(
            'ensure' => 'file',
            'notify' => 'Service[fail2ban]',
            'content' => %r{logpath  = /var/log/syslog\n /var/log/syslog\.1\n}
          )
        end
      end

      it do
        is_expected.to contain_file('custom_filter_spec_test_jail').with(
          'ensure' => 'file',
          'notify' => 'Service[fail2ban]',
          'content' => %r{failregex = Login failed for user .* from <HOST>}
        )
      end

      it do
        is_expected.to contain_file('custom_filter_spec_test_jail').with(
          'ensure' => 'file',
          'notify' => 'Service[fail2ban]',
          'content' => %r{maxlines = 10}
        )
      end

      it do
        is_expected.to contain_file('custom_filter_spec_test_jail').with(
          'ensure' => 'file',
          'notify' => 'Service[fail2ban]',
          'content' => %r{datepattern = %%Y-%%m-%%d %%H:%%M(?::%%S)?}
        )
      end
    end
  end
end
