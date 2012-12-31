# = Class: fail2ban::service
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
class fail2ban::service (
  $ensure_enable  = hiera('ensure_enable', $fail2ban::params::ensure_enable),
  $ensure_running = hiera('ensure_running', $fail2ban::params::ensure_running),
  $disabled_hosts = hiera('disabled_hosts', $fail2ban::params::disabled_hosts),

) inherits fail2ban::params {
  validate_bool($ensure_enable)
  validate_re($ensure_running, '^(running|stopped)$')
  validate_array($disabled_hosts)

  service { 'fail2ban':
    ensure     => $ensure_running,
    enable     => $ensure_enable,
    hasrestart => true,
    hasstatus  => true,
    require    => Class['fail2ban::config'],
  }

  if $::hostname in $disabled_hosts {
    Service <| title == 'fail2ban' |> {
      ensure => stopped,
      enable => false,
    }
  }
}
