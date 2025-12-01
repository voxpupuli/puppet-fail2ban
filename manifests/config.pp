# @summary Handles the configuration file.
#
# @api private
#
class fail2ban::config {
  assert_private()

  file { 'fail2ban.dir':
    ensure  => $fail2ban::config_dir_ensure,
    path    => $fail2ban::config_dir_path,
    force   => $fail2ban::config_dir_purge,
    notify  => $fail2ban::config_file_notify,
    require => $fail2ban::config_file_require,
  }

  file { 'jail.local':
    ensure  => $fail2ban::config_file_ensure,
    content => epp($fail2ban::config_file_template),
    path    => $fail2ban::config_file_path,
    owner   => $fail2ban::config_file_owner,
    group   => $fail2ban::config_file_group,
    mode    => $fail2ban::config_file_mode,
    notify  => $fail2ban::config_file_notify,
    require => $fail2ban::config_file_require,
  }

  # Operating system specific configuration
  case $facts['os']['family'] {
    'Debian': {
      file { 'defaults-debian.conf':
        ensure  => $fail2ban::debian_defaults_conf_ensure,
        path    => "${fail2ban::config_dir_path}/jail.d/defaults-debian.conf",
        notify  => $fail2ban::config_file_notify,
        require => $fail2ban::config_file_require,
      }
    }
    'RedHat': {
      file { '00-firewalld.conf':
        ensure  => $fail2ban::el_firewalld_conf_ensure,
        path    => "${fail2ban::config_dir_path}/jail.d/00-firewalld.conf",
        notify  => $fail2ban::config_file_notify,
        require => $fail2ban::config_file_require,
      }
    }
    'Suse':{
      # No defaults to deal with
    }
    default: {
      fail("${facts['os']['family']} not supported.")
    }
  }
}
