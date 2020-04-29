require 'spec_helper_acceptance'

case fact('osfamily')
when 'Debian'
  package_name          = 'fail2ban'
  config_file_path      = '/etc/fail2ban/jail.conf'
  service_name          = 'fail2ban'
  ssh_log_file          = '/var/log/auth.log'
  ssh_jail              = 'ssh'
when 'RedHat'
  package_name          = 'fail2ban'
  config_file_path      = '/etc/fail2ban/jail.conf'
  service_name          = 'fail2ban'
  ssh_log_file          = '/var/log/secure'
  ssh_jail              = 'ssh'
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
            service_ensure => 'stopped',
            service_enable => false,
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
            service_ensure => 'stopped',
            service_enable => false,
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
      end
    end

    context 'when content template' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban':
            config_file_template => "fail2ban/#{fact('os.name')}/#{fact('os.release.major')}/#{config_file_path}.epp",
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file(config_file_path) do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
        it { is_expected.to contain %r{^chain = INPUT$} }
      end
    end

    context 'when content template and custom chain' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban':
            config_file_template => "fail2ban/#{fact('os.name')}/#{fact('os.release.major')}/#{config_file_path}.epp",
            iptables_chain => 'TEST',
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file(config_file_path) do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
        it { is_expected.to contain %r{^chain = TEST$} }
      end
    end

    context 'when content template and custom banaction' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban':
            config_file_template => "fail2ban/#{fact('os.name')}/#{fact('os.release.major')}/#{config_file_path}.epp",
            banaction            => 'iptables'
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file(config_file_path) do
        it { is_expected.to be_file }
        it { is_expected.to contain %r{^banaction = iptables$} }
      end
    end

    context 'when content template and custom sender' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'fail2ban':
            config_file_template => "fail2ban/#{fact('os.name')}/#{fact('os.release.major')}/#{config_file_path}.epp",
            sender => 'custom-sender@example.com',
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file(config_file_path) do
        it { is_expected.to contain %r{^sender = custom-sender@example\.com$} }
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

    context 'when checking default running services' do
      it 'is expected.to have sshd and sshd-ddos enabled by default' do
        pp = <<-EOS
          class { 'fail2ban': }
        EOS
        apply_manifest(pp, catch_failures: true)
        fail2ban_status = shell('fail2ban-client status')
        expect(fail2ban_status.output).to contain ssh_jail
      end
    end

    # rubocop:disable RSpec/MultipleExpectations
    context 'when service start/stop notification are disabled' do
      it 'is expected.to have empty sshd actions' do
        pp = <<-EOS
          class { 'fail2ban':
            sendmail_actions => {
              actionstart => '',
              actionstop => '',
            }
          }
        EOS
        apply_manifest(pp, catch_failures: true)
        # fail2ban-client supports fetching config since version 0.9
        fail2ban_version = shell('LC_ALL=C fail2ban-server --version | head -n1 | awk \'{print $2}\' | cut -c 2-')
        if Gem::Version.new(fail2ban_version.output) >= Gem::Version.new('0.9.0')
          fail2ban_status = shell('fail2ban-client get sshd action sendmail-buffered actionstart')
          expect(fail2ban_status.output).to contain %r{^\n$}
        else
          fail2ban_status = shell('cat /etc/fail2ban/action.d/sendmail-buffered.conf | grep "after ="')
          expect(fail2ban_status.output).to contain %r{sendmail-common\.local$}
        end
      end
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
