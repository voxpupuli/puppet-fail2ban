require 'spec_helper'

describe 'fail2ban::define', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:pre_condition) { 'include fail2ban' }
      let(:title) { 'fail2ban.conf' }

      context 'when source file' do
        let(:params) do
          {
            config_file_source: 'puppet:///modules/fail2ban/wheezy/etc/fail2ban/jail.conf'
          }
        end

        it do
          is_expected.to contain_file('define_fail2ban.conf').with(
            'ensure'  => 'present',
            'source'  => 'puppet:///modules/fail2ban/wheezy/etc/fail2ban/jail.conf',
            'notify'  => 'Service[fail2ban]',
            'require' => 'Package[fail2ban]'
          )
        end
      end

      context 'when content string' do
        let(:params) do
          {
            config_file_string: '# THIS FILE IS MANAGED BY PUPPET'
          }
        end

        it do
          is_expected.to contain_file('define_fail2ban.conf').with(
            'ensure'  => 'present',
            'content' => %r{THIS FILE IS MANAGED BY PUPPET},
            'notify'  => 'Service[fail2ban]',
            'require' => 'Package[fail2ban]'
          )
        end
      end

      context 'when content template' do
        let(:params) do
          {
            config_file_template: 'fail2ban/wheezy/etc/fail2ban/jail.conf.erb'
          }
        end

        it do
          is_expected.to contain_file('define_fail2ban.conf').with(
            'ensure'  => 'present',
            'content' => %r{THIS FILE IS MANAGED BY PUPPET},
            'notify'  => 'Service[fail2ban]',
            'require' => 'Package[fail2ban]'
          )
        end
      end

      context 'when content template (custom)' do
        let(:params) do
          {
            config_file_template: 'fail2ban/wheezy/etc/fail2ban/jail.conf.erb',
            config_file_options_hash: {
              'key' => 'value'
            }
          }
        end

        it do
          is_expected.to contain_file('define_fail2ban.conf').with(
            'ensure'  => 'present',
            'content' => %r{THIS FILE IS MANAGED BY PUPPET},
            'notify'  => 'Service[fail2ban]',
            'require' => 'Package[fail2ban]'
          )
        end
      end
    end
  end
end
