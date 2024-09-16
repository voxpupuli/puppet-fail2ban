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
    purge   => $fail2ban::config_dir_purge,
    recurse => $fail2ban::config_dir_recurse,
    source  => $fail2ban::config_dir_source,
    notify  => $fail2ban::config_file_notify,
    require => $fail2ban::config_file_require,
  }

  if $fail2ban::config_file_path {
    file { 'fail2ban.conf':
      ensure  => $fail2ban::config_file_ensure,
      path    => $fail2ban::config_file_path,
      owner   => $fail2ban::config_file_owner,
      group   => $fail2ban::config_file_group,
      mode    => $fail2ban::config_file_mode,
      source  => $fail2ban::config_file_source,
      content => $fail2ban::config_file_content,
      notify  => $fail2ban::config_file_notify,
      require => $fail2ban::config_file_require,
    }
  }

  # Custom jails definition
  create_resources('fail2ban::jail', $fail2ban::custom_jails)

  # Operating system specific configuration
  case $facts['os']['family'] {
    'RedHat': {
      # Not using firewalld by now
      file { '00-firewalld.conf':
        ensure  => $fail2ban::manage_firewalld,
        path    => "${fail2ban::config_dir_path}/jail.d/00-firewalld.conf",
        notify  => $fail2ban::config_file_notify,
        require => $fail2ban::config_file_require,
      }
    }
    'Debian': {
      # Remove debian defaults conf
      file { 'defaults-debian.conf':
        ensure  => $fail2ban::manage_defaults,
        path    => "${fail2ban::config_dir_path}/jail.d/defaults-debian.conf",
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
  if !empty($fail2ban::sendmail_config) or !empty($fail2ban::sendmail_actions) {
    file { "${fail2ban::config_dir_path}/action.d":
      ensure  => 'directory',
      notify  => $fail2ban::config_file_notify,
      require => File[$fail2ban::config_dir_path],
    }

    file_line { 'sendmail_after_override':
      line    => 'after = sendmail-common.local',
      after   => 'before = sendmail-common.conf',
      path    => "${fail2ban::config_dir_path}/action.d/sendmail-buffered.conf",
      notify  => $fail2ban::config_file_notify,
      require => File["${fail2ban::config_dir_path}/action.d"],
    }

    file { "${fail2ban::config_dir_path}/action.d/sendmail-common.local":
      ensure  => $fail2ban::config_file_ensure,
      owner   => $fail2ban::config_file_owner,
      group   => $fail2ban::config_file_group,
      mode    => $fail2ban::config_file_mode,
      content => epp("${module_name}/common/sendmail.conf.epp",
        {
          actions => $fail2ban::sendmail_actions,
          config  => $fail2ban::sendmail_config,
        }
      ),
      notify  => $fail2ban::config_file_notify,
      require => File["${fail2ban::config_dir_path}/action.d"],
    }
  }
}
