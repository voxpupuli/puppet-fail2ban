# == Class: fail2ban::params
#
class fail2ban::params {
  $package_name = $::osfamily ? {
    default => 'fail2ban',
  }

  $package_list = $::osfamily ? {
    default => undef,
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/fail2ban',
  }

  $config_dir_filter_path = $::osfamily ? {
    default => '/etc/fail2ban/filter.d',
  }

  $config_file_path = $::osfamily ? {
    default => '/etc/fail2ban/jail.conf',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_notify = $::osfamily ? {
    default => 'Service[fail2ban]',
  }

  $config_file_require = $::osfamily ? {
    default => 'Package[fail2ban]',
  }

  $service_name = $::osfamily ? {
    default => 'fail2ban',
  }

  case $::osfamily {
    'Debian': {
    }
    'RedHat': {
    }
    default: {
      fail("${::operatingsystem} not supported.")
    }
  }
}
