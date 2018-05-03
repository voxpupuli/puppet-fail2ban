require 'spec_helper_acceptance'

case fact('osfamily')
when 'Debian'
  package_name          = 'fail2ban'
  config_file_path      = '/etc/fail2ban/jail.conf'
  service_name          = 'fail2ban'
  ssh_log_file          = '/var/log/auth.log'
  default_enabled_jails = 'ssh, ssh-ddos'
when 'RedHat'
  package_name          = 'fail2ban'
  config_file_path      = '/etc/fail2ban/jail.conf'
  service_name          = 'fail2ban'

  ssh_log_file          = '/var/log/secure'
  default_enabled_jails = 'sshd, sshd-ddos'
  # EPEL needs to be installed, otherwise it won't work
  shell('wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm')
  shell('rpm -ivh epel-release-latest-7.noarch.rpm && yum -y install redhat-lsb-core')
end

# Ensure the ssh log file is created, otherwise the service doesn't start completely
shell("touch #{ssh_log_file}")

puts(fact('lsbdistcodename'))

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
        # it { is_expected.not_to be_running }
        it { is_expected.not_to be_enabled }
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
            config_file_template => "fail2ban/#{fact('lsbdistcodename')}/#{config_file_path}.erb",
          }
        EOS

        apply_manifest(pp, catch_failures: true)
      end

      describe file(config_file_path) do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
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
        fail2ban_status = shell("fail2ban-client status")

        expect(fail2ban_status.output).to contain 'Number of jail:	2'
        expect(fail2ban_status.output).to contain default_enabled_jails
      end
    end 
  

  end
end
