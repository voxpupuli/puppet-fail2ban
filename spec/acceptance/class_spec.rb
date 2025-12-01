# frozen_string_literal: true

require 'spec_helper_acceptance'

package_name          = 'fail2ban'
config_file_path      = '/etc/fail2ban/jail.local'
service_name          = 'fail2ban'

case fact('osfamily')
when 'Debian'
  ssh_log_file          = '/var/log/auth.log'
when 'RedHat'
  ssh_log_file          = '/var/log/secure'
end

# Ensure the ssh log file is created, otherwise the service doesn't start completely
shell("touch #{ssh_log_file}")

describe 'fail2ban' do
  it 'is_expected.to work with no errors' do
    pp = <<-EOS
      class { 'fail2ban': }
    EOS

    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe 'fail2ban::install' do
    context 'defaults' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban': }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe package(package_name) do
        it { is_expected.to be_installed }
      end
    end

    context 'when package latest' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban':
            package_ensure => 'latest',
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe package(package_name) do
        it { is_expected.to be_installed }
      end
    end

    context 'when package absent' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban':
            package_ensure => 'absent',
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe package(package_name) do
        it { is_expected.not_to be_installed }
      end

      describe file(config_file_path) do
        it { is_expected.to be_file }
      end

      describe service(service_name) do
        it { is_expected.not_to be_running }
        # The docker images of Debian do not use systemd, the following test
        # cannot be performed on these images.

        it { is_expected.not_to be_enabled } if fact('osfamily') != 'Debian'
      end
    end

    context 'when package purged' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban':
            package_ensure => 'purged',
          }
        EOS

        apply_manifest(pp, expect_failures: false)
      end

      describe package(package_name) do
        it { is_expected.not_to be_installed }
      end

      describe file(config_file_path) do
        it { is_expected.not_to be_file }
      end

      describe service(service_name) do
        it { is_expected.not_to be_running }
        it { is_expected.not_to be_enabled }
      end
    end
  end

  describe 'fail2ban::config' do
    context 'defaults' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
            class { 'fail2ban': }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file(config_file_path) do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
        # By default the section must be empty
        it { is_expected.not_to contain %r{^ignoreip$} }
        it { is_expected.not_to contain %r{^bantime$} }
        it { is_expected.not_to contain %r{^maxretry$} }
        it { is_expected.not_to contain %r{^backend$} }
        it { is_expected.not_to contain %r{^destemail$} }
        it { is_expected.not_to contain %r{^sender$} }
        it { is_expected.not_to contain %r{^chain$} }
        it { is_expected.not_to contain %r{^banaction$} }
        it { is_expected.not_to contain %r{^banaction_allports$} }
        it { is_expected.not_to contain %r{^action$} }
      end
    end

    context 'all_default_section_params' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban':
            ignoreip           => ['127.0.0.1/8', '::1'],
            bantime            => 420,
            maxretry           => 42,
            default_backend    => 'auto',
            destemail          => 'custom-destination@example.com',
            sender             => 'custom-sender@example.com',
            iptables_chain     => 'INPUT',
            banaction          => 'iptables-multiport',
            banaction_allports => 'iptables-allports',
            action             => 'action_mw',
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file(config_file_path) do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
        it { is_expected.to contain %r{^ignoreip = 127.0.0.1/8, ::1$} }
        it { is_expected.to contain %r{^bantime = 420$} }
        it { is_expected.to contain %r{^maxretry = 42$} }
        it { is_expected.to contain %r{^backend = auto$} }
        it { is_expected.to contain %r{^chain = INPUT$} }
        it { is_expected.to contain %r{^destemail = custom-destination@example\.com$} }
        it { is_expected.to contain %r{^sender = custom-sender@example\.com$} }
        it { is_expected.to contain %r{^banaction = iptables-multiport$} }
        it { is_expected.to contain %r{^banaction_allports = iptables-allports$} }
        it { is_expected.to contain %r{^action = action_mw$} }
      end
    end

    context 'some_default_section_params' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban':
            ignoreip           => ['127.0.0.1/8', '::1'],
            bantime            => 420,
            maxretry           => 42,
            default_backend    => 'auto',
            iptables_chain     => 'INPUT',
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file(config_file_path) do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
        it { is_expected.to contain %r{^ignoreip = 127.0.0.1/8, ::1$} }
        it { is_expected.to contain %r{^bantime = 420$} }
        it { is_expected.to contain %r{^maxretry = 42$} }
        it { is_expected.to contain %r{^backend = auto$} }
        it { is_expected.to contain %r{^chain = INPUT$} }
        it { is_expected.not_to contain %r{^banaction$} }
        it { is_expected.not_to contain %r{^banaction_allports$} }
        it { is_expected.not_to contain %r{^action$} }
      end
    end

    context 'default_jails' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban':
            jails => {
              sshd => {
                enabled => true,
                bantime => '1h',
              },
              ssh-selinux => {
                enabled => false,
                bantime => '5m',
              },
            },
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file(config_file_path) do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
        it { is_expected.to contain '[sshd]' }
        it { is_expected.to contain %r{^enabled = true$} }
        it { is_expected.to contain %r{^bantime = 1h$} }
        it { is_expected.to contain '[ssh-selinux]' }
        it { is_expected.to contain %r{^enabled = false$} }
        it { is_expected.to contain %r{^bantime = 5m$} }
      end
    end
  end

  describe 'fail2ban::service' do
    context 'defaults' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban': }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe service(service_name) do
        it { is_expected.to be_running }
        it { is_expected.to be_enabled }
      end
    end

    context 'when service stopped' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban':
            service_ensure => 'stopped',
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe service(service_name) do
        it { is_expected.not_to be_running }
        it { is_expected.to be_enabled }
      end
    end

    context 'when service stopped and disabled' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban':
            service_ensure  => 'stopped',
            service_enable  => false,
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe service(service_name) do
        it { is_expected.not_to be_running }
        it { is_expected.not_to be_enabled }
      end
    end
  end

  describe 'fail2ban::resources' do
    context 'action_create' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban': }

          fail2ban::action { 'abuseipdb':
            action_name => 'abuseipdb',
            action_content => {
              'Definition' => {
                norestored => '0',
              },
              'Init' => {
                abuseipdb_apikey => 'my-very-secret-api-key',
              },
            },
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file('/etc/fail2ban/action.d/abuseipdb.local') do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
        it { is_expected.to contain '[Definition]' }
        it { is_expected.to contain %r{^norestored = 0$} }
        it { is_expected.to contain '[Init]' }
        it { is_expected.to contain %r{^abuseipdb_apikey = my-very-secret-api-key$} }
      end
    end

    context 'action_delete' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban': }

          fail2ban::action { 'abuseipdb':
            action_name => 'abuseipdb',
            action_ensure => 'absent',
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file('/etc/fail2ban/action.d/abuseipdb.local') do
        it { is_expected.not_to be_file }
      end
    end

    context 'filter_create' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban': }

          fail2ban::filter { 'common':
            filter_name    => 'common',
            filter_content => {
              'DEFAULT' => {
                'logtype' => 'short',
              },
            },
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file('/etc/fail2ban/filter.d/common.local') do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
        it { is_expected.to contain '[DEFAULT]' }
        it { is_expected.to contain %r{^logtype = short$} }
      end
    end

    context 'filter_delete' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban': }

          fail2ban::filter { 'common':
            filter_name    => 'common',
            filter_ensure  => absent,
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file('/etc/fail2ban/filter.d/common.local') do
        it { is_expected.not_to be_file }
      end
    end

    context 'jail_create' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban': }

          fail2ban::jail { 'nginx-wp-login':
            jail_name    => 'nginx-wp-login',
            jail_content => {
              'nginx-wp-login' => {
                jail_failregex => '<HOST>.*] "POST /wp-login.php',
                port           => 'http,https',
                logpath        => '/var/log/nginx/access.log',
              },
            },
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file('/etc/fail2ban/jail.d/nginx-wp-login.local') do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
        it { is_expected.to contain '[nginx-wp-login]' }
        it { is_expected.to contain 'jail_failregex = <HOST>.*] "POST /wp-login.php' }
        it { is_expected.to contain %r{^port = http,https$} }
        it { is_expected.to contain %r{^logpath = /var/log/nginx/access.log$} }
      end
    end

    context 'jail_delete' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban': }

          fail2ban::jail { 'nginx-wp-login':
            jail_name    => 'nginx-wp-login',
            jail_ensure  => absent,
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file('/etc/fail2ban/jail.d/nginx-wp-login.local') do
        it { is_expected.not_to be_file }
      end
    end
  end
end
