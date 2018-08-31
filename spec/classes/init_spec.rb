require 'spec_helper'

describe 'fail2ban', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      begin
        distname = facts[:os]['lsb']['distcodename']
      rescue
        distname = case facts[:os]['family']
                   when 'RedHat'
                     case facts[:os]['release']['major']
                     when '6'
                       'Santiago'
                     when '7'
                       'Maipo'
                     else
                       'unsupported_RedHat'
                     end
                   else
                     'unsupported'
                   end
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_anchor('fail2ban::begin') }
      it { is_expected.to contain_class('fail2ban::params') }
      it { is_expected.to contain_class('fail2ban::install') }
      it { is_expected.to contain_class('fail2ban::config') }
      it { is_expected.to contain_class('fail2ban::service') }
      it { is_expected.to contain_anchor('fail2ban::end') }

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
            is_expected.to contain_file('fail2ban.conf').with(
              'ensure'  => 'present',
              'notify'  => 'Service[fail2ban]',
              'require' => 'Package[fail2ban]'
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
            is_expected.to contain_file('fail2ban.conf').with(
              'ensure'  => 'absent',
              'notify'  => 'Service[fail2ban]',
              'require' => 'Package[fail2ban]'
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

      describe 'fail2ban::config' do
        context 'defaults' do
          it do
            is_expected.to contain_file('fail2ban.conf').with(
              'ensure'  => 'present',
              'notify'  => 'Service[fail2ban]',
              'require' => 'Package[fail2ban]'
            )
          end
        end

        context 'when source dir' do
          let(:params) do
            {
              config_dir_source: 'puppet:///modules/fail2ban/wheezy/etc/fail2ban'
            }
          end

          it do
            is_expected.to contain_file('fail2ban.dir').with(
              'ensure'  => 'directory',
              'force'   => false,
              'purge'   => false,
              'recurse' => true,
              'source'  => 'puppet:///modules/fail2ban/wheezy/etc/fail2ban',
              'notify'  => 'Service[fail2ban]',
              'require' => 'Package[fail2ban]'
            )
          end
        end

        context 'when source dir purged' do
          let(:params) do
            {
              config_dir_purge: true,
              config_dir_source: 'puppet:///modules/fail2ban/wheezy/etc/fail2ban'
            }
          end

          it do
            is_expected.to contain_file('fail2ban.dir').with(
              'ensure'  => 'directory',
              'force'   => true,
              'purge'   => true,
              'recurse' => true,
              'source'  => 'puppet:///modules/fail2ban/wheezy/etc/fail2ban',
              'notify'  => 'Service[fail2ban]',
              'require' => 'Package[fail2ban]'
            )
          end
        end

        context 'when source file' do
          let(:params) do
            {
              config_file_source: 'puppet:///modules/fail2ban/wheezy/etc/fail2ban/jail.conf'
            }
          end

          it do
            is_expected.to contain_file('fail2ban.conf').with(
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
            is_expected.to contain_file('fail2ban.conf').with(
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
              config_file_template: "fail2ban/#{distname}/etc/fail2ban/jail.conf.epp"
            }
          end

          it do
            is_expected.to contain_file('fail2ban.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'notify'  => 'Service[fail2ban]',
              'require' => 'Package[fail2ban]'
            ).with_content(%r{^chain = INPUT$})
          end
        end

        context 'when content template (custom)' do
          let(:params) do
            {
              config_file_template: "fail2ban/#{distname}/etc/fail2ban/jail.conf.epp",
              config_file_options_hash: {
                'key' => 'value'
              }
            }
          end

          it do
            is_expected.to contain_file('fail2ban.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'notify'  => 'Service[fail2ban]',
              'require' => 'Package[fail2ban]'
            ).with_content(%r{^chain = INPUT$})
          end
        end

        context 'when iptables chain provided' do
          let(:params) do
            {
              config_file_template: "fail2ban/#{distname}/etc/fail2ban/jail.conf.epp",
              iptables_chain: 'TEST'
            }
          end

          it do
            is_expected.to contain_file('fail2ban.conf').with_content(
              %r{^chain = TEST$}
            )
          end
        end

        context 'when custom banaction is provided' do
          let(:params) do
            {
              config_file_template: "fail2ban/#{distname}/etc/fail2ban/jail.conf.epp",
              banaction: 'iptables'
            }
          end

          it do
            is_expected.to contain_file('fail2ban.conf').with_content(
              %r{^banaction = iptables$}
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

      describe 'fail2ban::jail' do
        it do
          is_expected.to compile.with_all_deps
        end
      end
    end
  end
end
