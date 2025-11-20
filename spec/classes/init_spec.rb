# frozen_string_literal: true

require 'spec_helper'

describe 'fail2ban', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:config_file_template) do
        'fail2ban/jail.local.epp'
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('fail2ban::install').that_comes_before('Class[fail2ban::config]') }
      it { is_expected.to contain_class('fail2ban::config').that_notifies('Class[fail2ban::service]') }
      it { is_expected.to contain_class('fail2ban::service') }
      it { is_expected.to contain_class('fail2ban').with_config_file_template('fail2ban/jail.local.epp') }

      describe 'fail2ban::install' do
        context 'defaults' do
          it do
            is_expected.to contain_package('fail2ban').with(
              'ensure' => 'present'
            )
          end
        end

        context 'when package latest' do
          let(:params) do
            {
              package_ensure: 'latest'
            }
          end

          it do
            is_expected.to contain_package('fail2ban').with(
              'ensure' => 'latest'
            )
          end
        end

        context 'when package absent' do
          let(:params) do
            {
              package_ensure: 'absent',
              service_ensure: 'stopped',
              service_enable: false
            }
          end

          it do
            is_expected.to contain_package('fail2ban').with(
              'ensure' => 'absent'
            )
          end

          it do
            is_expected.to contain_service('fail2ban').with(
              'ensure' => 'stopped',
              'enable' => false
            )
          end
        end

        context 'when package purged' do
          let(:params) do
            {
              package_ensure: 'purged',
              service_ensure: 'stopped',
              service_enable: false
            }
          end

          it do
            is_expected.to contain_package('fail2ban').with(
              'ensure' => 'purged'
            )
          end

          it do
            is_expected.to contain_service('fail2ban').with(
              'ensure' => 'stopped',
              'enable' => false
            )
          end
        end
      end

      case facts[:os]['family']
      when 'RedHat'
        context 'when manage_firewalld' do
          let(:params) do
            {
              el_firewalld_conf_ensure: 'absent'
            }
          end

          it do
            is_expected.to contain_file('00-firewalld.conf').with(
              'ensure' => 'absent',
              'path' => '/etc/fail2ban/jail.d/00-firewalld.conf',
              'notify' => 'Service[fail2ban]',
              'require' => 'Package[fail2ban]'
            )
          end
        end
      when 'Debian'
        context 'when manage_defaults' do
          let(:params) do
            {
              debian_defaults_conf_ensure: 'absent'
            }
          end

          it do
            is_expected.to contain_file('defaults-debian.conf').with(
              'ensure' => 'absent',
              'path' => '/etc/fail2ban/jail.d/defaults-debian.conf',
              'notify' => 'Service[fail2ban]',
              'require' => 'Package[fail2ban]'
            )
          end
        end
      end

      describe 'fail2ban::service' do
        context 'defaults' do
          it do
            is_expected.to contain_service('fail2ban').with(
              'ensure' => 'running',
              'enable' => true
            )
          end
        end

        context 'when service stopped' do
          let(:params) do
            {
              service_ensure: 'stopped'
            }
          end

          it do
            is_expected.to contain_service('fail2ban').with(
              'ensure' => 'stopped',
              'enable' => true
            )
          end
        end
      end
    end
  end
end
