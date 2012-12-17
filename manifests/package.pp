# = Class: fail2ban::package
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
class fail2ban::package (
  $ensure = hiera('ensure', $fail2ban::params::ensure),
) inherits fail2ban::params {
  validate_re($ensure, '^(absent|present)$')

  package { 'fail2ban':
    ensure => $ensure,
  }
}
