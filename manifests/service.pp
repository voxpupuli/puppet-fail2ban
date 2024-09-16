# @summary Handles the service.
#
# @api private
#
class fail2ban::service {
  assert_private()

  if $fail2ban::service_name {
    service { 'fail2ban':
      ensure     => $fail2ban::_service_ensure,
      name       => $fail2ban::service_name,
      enable     => $fail2ban::_service_enable,
      hasrestart => true,
    }
  }
}
