# = Class: fail2ban::config
#
# This module manages fail2ban
#
# == Parameters: none
#
# == Actions:
#
# == Requires: see Modulefile
#
# == Sample Usage:
#
class fail2ban::config (
  $ensure    = hiera('ensure', $fail2ban::params::ensure),
  $email     = hiera('email', $fail2ban::params::email),
  $whitelist = hiera('whitelist', $fail2ban::params::whitelist),
) inherits fail2ban::params {
  validate_re($ensure, '^(absent|present)$')
  validate_string($email)
  validate_array($whitelist)

  file {
    '/etc/fail2ban/jail.conf':
      ensure  => $ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("fail2ban/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb"),
      notify  => Service['fail2ban'],
      require => Package['fail2ban'];
    '/etc/fail2ban/jail.local':
      ensure  => $ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/fail2ban/common/etc/fail2ban/jail.local',
      notify  => Service['fail2ban'],
      require => Package['fail2ban'];
  }
}
