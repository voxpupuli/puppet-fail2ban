# = Class: fail2ban::params
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
class fail2ban::params {
  case $::lsbdistcodename {
    'squeeze', 'wheezy', 'precise', 'quantal': {
      $ensure           = present
      $ensure_enable    = true
      $ensure_running   = running
      $email            = "fail2ban@${::domain}"
      $whitelist        = [
        '127.0.0.1',
        '192.168.122.0/24'
      ]
    }
    default: {
      fail("Module ${module_name} does not support ${::lsbdistcodename}")
    }
  }
}
