require 'spec_helper'

describe 'fail2ban::define', :type => :define do
  ['Debian'].each do |osfamily|
    let(:facts) {{
      :osfamily => osfamily,
    }}
    let(:pre_condition) { 'include fail2ban' }
    let(:title) { 'fail2ban.conf' }

    context "on #{osfamily}" do
      context 'when source file' do
        let(:params) {{
          :config_file_source => 'puppet:///modules/fail2ban/wheezy/etc/fail2ban/jail.conf',
        }}

        it do
          is_expected.to contain_file('define_fail2ban.conf').with({
            'ensure'  => 'present',
            'source'  => 'puppet:///modules/fail2ban/wheezy/etc/fail2ban/jail.conf',
            'notify'  => 'Service[fail2ban]',
            'require' => 'Package[fail2ban]',
          })
        end
      end

      context 'when content string' do
        let(:params) {{
          :config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
        }}

        it do
          is_expected.to contain_file('define_fail2ban.conf').with({
            'ensure'  => 'present',
            'content' => /THIS FILE IS MANAGED BY PUPPET/,
            'notify'  => 'Service[fail2ban]',
            'require' => 'Package[fail2ban]',
          })
        end
      end

      context 'when content template' do
        let(:params) {{
          :config_file_template => 'fail2ban/wheezy/etc/fail2ban/jail.conf.erb',
        }}

        it do
          is_expected.to contain_file('define_fail2ban.conf').with({
            'ensure'  => 'present',
            'content' => /THIS FILE IS MANAGED BY PUPPET/,
            'notify'  => 'Service[fail2ban]',
            'require' => 'Package[fail2ban]',
          })
        end
      end

      context 'when content template (custom)' do
        let(:params) {{
          :config_file_template     => 'fail2ban/wheezy/etc/fail2ban/jail.conf.erb',
          :config_file_options_hash => {
            'key' => 'value',
          },
        }}

        it do
          is_expected.to contain_file('define_fail2ban.conf').with({
            'ensure'  => 'present',
            'content' => /THIS FILE IS MANAGED BY PUPPET/,
            'notify'  => 'Service[fail2ban]',
            'require' => 'Package[fail2ban]',
          })
        end
      end
    end
  end
end
