require 'spec_helper'

describe 'fail2ban', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      # Hard code one existing template as a custom template
      let(:config_file_template) do
        'fail2ban/RedHat/8/etc/fail2ban/jail.conf.epp'
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('fail2ban::install').that_comes_before('Class[fail2ban::config]') }
      it { is_expected.to contain_class('fail2ban::config').that_notifies('Class[fail2ban::service]') }
      it { is_expected.to contain_class('fail2ban::service') }
      case [facts[:os]['name'], facts[:os]['release']['major']]
      when %w[OpenSuSE 15]
        it { is_expected.to contain_class('fail2ban').with_config_file_template('fail2ban/OpenSuSE/15/etc/fail2ban/jail.conf.epp') }
      when %w[CentOS 7]
        it { is_expected.to contain_class('fail2ban').with_config_file_template('fail2ban/CentOS/7/etc/fail2ban/jail.conf.epp') }
      when %w[RedHat 7]
        it { is_expected.to contain_class('fail2ban').with_config_file_template('fail2ban/RedHat/7/etc/fail2ban/jail.conf.epp') }
      when %w[AlmaLinux 8], %w[RedHat 8], %w[Rocky 8], %w[CentOS 8]
        it { is_expected.to contain_class('fail2ban').with_config_file_template('fail2ban/RedHat/8/etc/fail2ban/jail.conf.epp') }
      when %w[AlmaLinux 9], %w[RedHat 9], %w[Rocky 9], %w[CentOS 9]
        it { is_expected.to contain_class('fail2ban').with_config_file_template('fail2ban/RedHat/9/etc/fail2ban/jail.conf.epp') }
      when %w[Debian 10]
        it { is_expected.to contain_class('fail2ban').with_config_file_template('fail2ban/Debian/10/etc/fail2ban/jail.conf.epp') }
      when %w[Debian 11]
        it { is_expected.to contain_class('fail2ban').with_config_file_template('fail2ban/Debian/11/etc/fail2ban/jail.conf.epp') }
      when ['Ubuntu', '18.04']
        it { is_expected.to contain_class('fail2ban').with_config_file_template('fail2ban/Ubuntu/18.04/etc/fail2ban/jail.conf.epp') }
      when ['Ubuntu', '20.04']
        it { is_expected.to contain_class('fail2ban').with_config_file_template('fail2ban/Ubuntu/20.04/etc/fail2ban/jail.conf.epp') }
      else
        # has to be better way of doing this.
        it { is_expected.to contain_class('fail2ban').with_config_file_template('a new os.name or os.release.major needs a new case') }
      end

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
              config_dir_source: 'puppet:///modules/profile/fail2ban/etc/fail2ban'
            }
          end

          it do
            is_expected.to contain_file('fail2ban.dir').with(
              'ensure'  => 'directory',
              'force'   => false,
              'purge'   => false,
              'recurse' => true,
              'source'  => 'puppet:///modules/profile/fail2ban/etc/fail2ban',
              'notify'  => 'Service[fail2ban]',
              'require' => 'Package[fail2ban]'
            )
          end
        end

        context 'when source dir purged' do
          let(:params) do
            {
              config_dir_purge: true,
              config_dir_source: 'puppet:///modules/profile/fail2ban/etc/fail2ban'
            }
          end

          it do
            is_expected.to contain_file('fail2ban.dir').with(
              'ensure'  => 'directory',
              'force'   => true,
              'purge'   => true,
              'recurse' => true,
              'source'  => 'puppet:///modules/profile/fail2ban/etc/fail2ban',
              'notify'  => 'Service[fail2ban]',
              'require' => 'Package[fail2ban]'
            )
          end
        end

        context 'when source file' do
          let(:params) do
            {
              config_file_source: 'puppet:///modules/profile/fail2ban/etc/fail2ban/jail.conf'
            }
          end

          it do
            is_expected.to contain_file('fail2ban.conf').with(
              'ensure'  => 'present',
              'source'  => 'puppet:///modules/profile/fail2ban/etc/fail2ban/jail.conf',
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
              config_file_template: config_file_template
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
              config_file_template: config_file_template,
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

        case facts[:os]['family']
        when 'RedHat'
          context 'when manage_firewalld' do
            let(:params) do
              {
                manage_firewalld: 'present'
              }
            end

            it do
              is_expected.to contain_file('00-firewalld.conf').with(
                'ensure'  => 'present',
                'path'    => '/etc/fail2ban/jail.d/00-firewalld.conf',
                'notify'  => 'Service[fail2ban]',
                'require' => 'Package[fail2ban]'
              )
            end
          end
        when 'Debian'
          context 'when manage_defaults' do
            let(:params) do
              {
                manage_defaults: 'present'
              }
            end

            it do
              is_expected.to contain_file('defaults-debian.conf').with(
                'ensure'  => 'present',
                'path'    => '/etc/fail2ban/jail.d/defaults-debian.conf',
                'require' => 'Package[fail2ban]'
              )
            end
          end
        end

        context 'when iptables chain provided' do
          let(:params) do
            {
              config_file_template: config_file_template,
              iptables_chain: 'TEST'
            }
          end

          it do
            is_expected.to contain_file('fail2ban.conf').with_content(
              %r{^chain = TEST$}
            )
          end
        end

        context 'when bantime provided as string' do
          let(:params) do
            {
              config_file_template: config_file_template,
              bantime: '12h'
            }
          end

          it do
            is_expected.to contain_file('fail2ban.conf').with_content(
              %r{^bantime  = 12h$}
            )
          end
        end

        context 'when custom banaction is provided' do
          let(:params) do
            {
              config_file_template: config_file_template,
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

      describe 'sendmail' do
        let(:params) do
          {
            sendmail_config: {
              dest: 'root',
              sender: 'fail2ban@localhost'
            },
            sendmail_actions: {
              actionstart: '',
              actionstop: ''
            }
          }
        end

        it do
          is_expected.to contain_file('/etc/fail2ban/action.d').with(
            ensure: 'directory'
          )
        end

        it do
          is_expected.to contain_file_line('sendmail_after_override').with(
            path: '/etc/fail2ban/action.d/sendmail-buffered.conf',
            line: 'after = sendmail-common.local',
            after: 'before = sendmail-common.conf'
          )
        end

        it do
          is_expected.to contain_file('/etc/fail2ban/action.d/sendmail-common.local').with_content(
            %r{^dest = root$}
          )
        end

        it do
          is_expected.to contain_file('/etc/fail2ban/action.d/sendmail-common.local').with_content(
            %r{^sender = fail2ban@localhost$}
          )
        end

        it do
          is_expected.to contain_file('/etc/fail2ban/action.d/sendmail-common.local').with_content(
            %r{^actionstart = $}
          )
        end

        it do
          is_expected.to contain_file('/etc/fail2ban/action.d/sendmail-common.local').with_content(
            %r{^actionstop = $}
          )
        end
      end

      describe 'sendmail not managed by default' do
        let(:params) do
          {
            sendmail_config: {
            },
            sendmail_actions: {
            }
          }
        end

        it do
          is_expected.not_to contain_file('/etc/fail2ban/action.d/sendmail-common.local')
        end

        it do
          is_expected.not_to contain_file('/etc/fail2ban/action.d').with(
            ensure: 'directory'
          )
        end
      end
    end
  end
end
