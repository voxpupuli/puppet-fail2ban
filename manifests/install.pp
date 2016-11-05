# == Class: fail2ban::install
#
class fail2ban::install {
  if $::fail2ban::package_name_real {
    package { 'fail2ban':
      ensure => $::fail2ban::package_ensure,
      name   => $::fail2ban::package_name_real,
    }
  }

  if $::fail2ban::package_list_real {
    ensure_resource('package', $::fail2ban::package_list_real, { 'ensure' => $::fail2ban::package_ensure })
  }
}
