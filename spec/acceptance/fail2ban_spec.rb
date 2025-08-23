# frozen_string_literal: true

require 'spec_helper_acceptance'

case fact('os.family')
when 'Debian'
  package_name          = 'fail2ban'
  config_file_path      = '/etc/fail2ban/jail.conf'
  service_name          = 'fail2ban'
  ssh_log_file          = '/var/log/auth.log'
  ssh_jail              = 'sshd'
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
  context 'with defaults' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-EOS
      class { 'fail2ban': }
        EOS
      end
    end

    describe package(package_name) do
      it { is_expected.to be_installed }
    end

    describe file(config_file_path) do
      it { is_expected.to be_file }
    end

    describe service(service_name) do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe command('fail2ban-client status') do
      its(:stdout) { is_expected.to match %r{Jail list:\s+#{ssh_jail}} }
    end
  end

  context 'when package absent' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-EOS
      class { 'fail2ban':
        package_ensure => 'absent',
        service_ensure => 'stopped',
        service_enable => false,
      }
        EOS
      end
    end

    describe package(package_name) do
      it { is_expected.not_to be_installed }
    end

    describe file(config_file_path) do
      it { is_expected.to be_file }
    end

    describe service(service_name) do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end
  end

  context 'when content template' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-EOS
      $_config_file_template = $facts['os']['family'] ? {
        'RedHat' => "fail2ban/RedHat/#{fact('os.release.major')}/#{config_file_path}.epp",
        default  => "fail2ban/#{fact('os.name')}/#{fact('os.release.major')}/#{config_file_path}.epp",
      }
      class { 'fail2ban':
        config_file_template => $_config_file_template,
      }
        EOS
      end
    end

    describe file(config_file_path) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
      it { is_expected.to contain %r{^chain = INPUT$} }
    end
  end

  context 'when content template and custom chain' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-EOS
      $_config_file_template = $facts['os']['family'] ? {
        'RedHat' => "fail2ban/RedHat/#{fact('os.release.major')}/#{config_file_path}.epp",
        default  => "fail2ban/#{fact('os.name')}/#{fact('os.release.major')}/#{config_file_path}.epp",
      }
      class { 'fail2ban':
        config_file_template => $_config_file_template,
        iptables_chain => 'TEST',
      }
        EOS
      end
    end

    describe file(config_file_path) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
      it { is_expected.to contain %r{^chain = TEST$} }
    end
  end

  context 'when content template and custom banaction' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-EOS
      $_config_file_template = $facts['os']['family'] ? {
        'RedHat' => "fail2ban/RedHat/#{fact('os.release.major')}/#{config_file_path}.epp",
        default  => "fail2ban/#{fact('os.name')}/#{fact('os.release.major')}/#{config_file_path}.epp",
      }
      class { 'fail2ban':
        config_file_template => $_config_file_template,
        banaction            => 'iptables'
      }
        EOS
      end
    end

    describe file(config_file_path) do
      it { is_expected.to be_file }
      it { is_expected.to contain %r{^banaction = iptables$} }
    end
  end

  context 'when content template and custom sender' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-EOS
      $_config_file_template = $facts['os']['family'] ? {
        'RedHat' => "fail2ban/RedHat/#{fact('os.release.major')}/#{config_file_path}.epp",
        default  => "fail2ban/#{fact('os.name')}/#{fact('os.release.major')}/#{config_file_path}.epp",
      }
      class { 'fail2ban':
        config_file_template => $_config_file_template,
        sender => 'custom-sender@example.com',
      }
        EOS
      end
    end

    describe file(config_file_path) do
      it { is_expected.to contain %r{^sender = custom-sender@example\.com$} }
    end
  end

  context 'when service stopped' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-EOS
      class { 'fail2ban':
        service_ensure => 'stopped',
      }
        EOS
      end
    end

    describe service(service_name) do
      it { is_expected.not_to be_running }
      it { is_expected.to be_enabled }
    end
  end

  context 'when service start/stop notification are disabled' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-EOS
      class { 'fail2ban':
        sendmail_actions => {
          actionstart => '',
          actionstop => '',
        }
      }
        EOS
      end
    end

    # fail2ban-client supports fetching config since version 0.9
    fail2ban_version = shell('fail2ban-server --version | head -n1 | awk \'{print $2}\' | cut -c 2- | tail -n1')
    if Gem::Version.new(fail2ban_version.stdout) >= Gem::Version.new('0.9.0')
      describe command('fail2ban-client get sshd action sendmail-buffered actionstart') do
        its(:stdout) { is_expected.to match %r{^\n$} }
      end
    else
      describe command('cat /etc/fail2ban/action.d/sendmail-buffered.conf | grep "after ="') do
        its(:stdout) { is_expected.to match %r{sendmail-common\.local$} }
      end
    end
  end

  context 'when package purged' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-EOS
      class { 'fail2ban':
        package_ensure => 'purged',
        service_ensure => 'stopped',
        service_enable => false,
        config_dir_purge => true,
      }
        EOS
      end
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
