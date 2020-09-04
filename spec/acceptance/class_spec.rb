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

def fail2ban_is_at_least(version)
  res = shell('fail2ban-server --version | awk \'/Fail2Ban v/ {print substr($2,2); EXIT}\'')
  Gem::Version.new(res.stdout) >= Gem::Version.new(version)
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
        if fail2ban_is_at_least('0.9.0')
          fail2ban_status = shell('fail2ban-client get sshd action sendmail-buffered actionstart')
          expect(fail2ban_status.output).to contain %r{^\n$}
        else
          fail2ban_status = shell('cat /etc/fail2ban/action.d/sendmail-buffered.conf | grep "after ="')
          expect(fail2ban_status.output).to contain %r{sendmail-common\.local$}
        end
      end
    end

    # rubocop:enable RSpec/MultipleExpectations
    context 'when overriding default port configuration' do
      before(:all) do
        pp = <<-EOS
          class { 'fail2ban': }
        EOS
        yaml = <<-EOS
fail2ban::jails_config:
  ssh:
    port: 'ssh,2200'
  dropbear:
    port: 'ssh,2201'
  selinux-ssh:
    port: 'ssh,2202'
  apache-auth:
    port: '80,443'
  apache-badbots:
    port: '80,443'
  apache-noscript:
    port: '80,443'
  apache-overflows:
    port: '80,443'
  apache-nohome:
    port: '80,443'
  apache-botsearch:
    port: '80,443'
  apache-fakegooglebot:
    port: '80,443'
  apache-modsecurity:
    port: '80,443'
  apache-shellshock:
    port: '80,443'
  nginx-http-auth:
    port: '80,443'
  nginx-limit-req:
    port: '80,443'
  nginx-botsearch:
    port: '80,443'
  php-url-fopen:
    port: '80,443'
  suhosin:
    port: '80,443'
  lighttpd-auth:
    port: '80,443'
  roundcube-auth:
    port: '80,443'
  openwebmail:
    port: '80,443'
  horde:
    port: '80,443'
  groupoffice:
    port: '80,443'
  sogo-auth:
    port: '80,443'
  tine20:
    port: '80,443'
  drupal-auth:
    port: '80,443'
  guacamole:
    port: '80,443'
  monit:
    port: 2811
EOS
        shell "echo \"#{yaml}\" > /etc/puppetlabs/code/environments/production/data/common.yaml"

        apply_manifest(pp, catch_failures: true)
      end

      # fail2ban version check must be inside "it" block,
      # so that the variable will be evaluated
      # after package installation
      it 'is expected to modify sshd port' do
        r = if fact('os.family') == 'Debian' && fact('os.release.major') == '8'
              # Debian 8 is calling jail `ssh` instead of `sshd`
              shell("grep \"\\[ssh\\]\" -A 10 #{config_file_path}")
            else
              shell("grep \"\\[sshd\\]\" -A 10 #{config_file_path}")
            end
        expect(r.stdout).to match %r{^port\s+\=\s+ssh,2200$}
      end

      it 'is expected to modify lighttpd-auth port' do
        if fail2ban_is_at_least('0.8.7')
          shell("grep \"\\[lighttpd-auth\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify roundcube-auth port' do
        if fail2ban_is_at_least('0.8.9')
          shell("grep \"\\[roundcube-auth\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify apache-nohome port' do
        if fail2ban_is_at_least('0.8.10')
          shell("grep \"\\[apache-nohome\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify suhosin port' do
        if fail2ban_is_at_least('0.9.0')
          shell("grep \"\\[suhosin\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify selinux-ssh port' do
        # since 0.8.11
        unless fact('os.family') == 'Debian' && fact('os.release.major') == '8'
          shell("grep \"\\[selinux-ssh\\]\" -A 5 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+ssh,2202$}
          end
        end
      end

      it 'is expected to modify apache-auth port' do
        # since 0.8.11
        unless fact('os.family') == 'Debian' && fact('os.release.major') == '8'
          shell("grep \"\\[apache-auth\\]\" -A 5 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify horde port' do
        # since 0.8.11
        unless fact('os.family') == 'Debian' && fact('os.release.major') == '8'
          shell("grep \"\\[horde\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify groupoffice port' do
        # since 0.8.11
        unless fact('os.family') == 'Debian' && fact('os.release.major') == '8'
          shell("grep \"\\[groupoffice\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify openwebmail port' do
        # since 0.8.11
        unless fact('os.family') == 'Debian' && fact('os.release.major') == '8'
          shell("grep \"\\[openwebmail\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify apache-botsearch port' do
        if fail2ban_is_at_least('0.9.0')
          shell("grep \"\\[apache-botsearch\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify apache-shellshock port' do
        if fail2ban_is_at_least('0.9.0')
          shell("grep \"\\[apache-shellshock\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify tine20 port' do
        if fail2ban_is_at_least('0.9.0')
          shell("grep \"\\[tine20\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify nginx-botsearch port' do
        if fail2ban_is_at_least('0.9.2')
          shell("grep \"\\[nginx-botsearch\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify nginx-limit-req port' do
        case fact('os.family')
        when 'Debian'
          if fail2ban_is_at_least('0.9.4')
            shell("grep \"\\[nginx-limit-req\\]\" -A 6 #{config_file_path}") do |r|
              expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
            end
          end
        when 'RedHat'
          if fact('os.release.major').to_i >= 8
            shell("grep \"\\[nginx-limit-req\\]\" -A 6 #{config_file_path}") do |r|
              expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
            end
          end
        end
      end

      it 'is expected to modify apache-badbots port' do
        if fail2ban_is_at_least('0.9.4')
          shell("grep \"\\[apache-badbots\\]\" -A 7 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify apache-fakegooglebot port' do
        if fail2ban_is_at_least('0.9.6')
          shell("grep \"\\[apache-fakegooglebot\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify dropbear port' do
        shell("grep \"\\[dropbear\\]\" -A 5 #{config_file_path}") do |r|
          expect(r.stdout).to match %r{^port\s+\=\s+ssh,2201$}
        end
      end

      it 'is expected to modify apache-modsecurity port' do
        shell("grep \"\\[apache-modsecurity\\]\" -A 6 #{config_file_path}") do |r|
          expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
        end
      end

      it 'is expected to modify nginx-http-auth port' do
        shell("grep \"\\[nginx-http-auth\\]\" -A 6 #{config_file_path}") do |r|
          expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
        end
      end

      it 'is expected to modify apache-noscript port' do
        shell("grep \"\\[apache-noscript\\]\" -A 6 #{config_file_path}") do |r|
          expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
        end
      end

      it 'is expected to modify apache-overflows port' do
        shell("grep \"\\[apache-overflows\\]\" -A 6 #{config_file_path}") do |r|
          expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
        end
      end

      it 'is expected to modify sogo-auth port' do
        shell("grep \"\\[sogo-auth\\]\" -A 6 #{config_file_path}") do |r|
          expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
        end
      end

      it 'is expected to modify php-url-fopen port' do
        shell("grep \"\\[php-url-fopen\\]\" -A 6 #{config_file_path}") do |r|
          expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
        end
      end

      it 'is expected to modify drupal-auth port' do
        if fail2ban_is_at_least('0.9.0')
          shell("grep \"\\[drupal-auth\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify guacamole port' do
        if fail2ban_is_at_least('0.9.0')
          shell("grep \"\\[guacamole\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+80,443$}
          end
        end
      end

      it 'is expected to modify monit port' do
        if fail2ban_is_at_least('0.9.1')
          shell("grep \"\\[monit\\]\" -A 6 #{config_file_path}") do |r|
            expect(r.stdout).to match %r{^port\s+\=\s+2811$}
          end
        end
      end
    end
  end
end
