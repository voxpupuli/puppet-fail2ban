# == Class: fail2ban::service
#
class fail2ban::service {
  if $::fail2ban::service_name_real {
    service { 'fail2ban':
      ensure     => $::fail2ban::_service_ensure,
      name       => $::fail2ban::service_name_real,
      enable     => $::fail2ban::_service_enable,
      hasrestart => true,
    }
  }
}
