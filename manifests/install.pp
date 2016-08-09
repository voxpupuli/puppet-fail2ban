# == Class: fail2ban::install
#
class fail2ban::install {
  if $::fail2ban::package_name {
    package { 'fail2ban':
      ensure => $::fail2ban::package_ensure,
      name   => $::fail2ban::package_name,
    }

    file { "$::fail2ban::config_dir_path/jail.d/defaults-debian.conf":
      ensure => "absent",
      require => Package['fail2ban'],
    }
  }

  if $::fail2ban::package_list {
    ensure_resource('package', $::fail2ban::package_list, { 'ensure' => $::fail2ban::package_ensure })
  }
}
