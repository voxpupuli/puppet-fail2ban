# = Class: fail2ban
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
class fail2ban {
  class { 'fail2ban::package': }
  class { 'fail2ban::config': }
  class { 'fail2ban::service': }
}
