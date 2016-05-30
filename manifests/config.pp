# == Class: fail2ban::config
#
class fail2ban::config {
  # Load custom jails definition
  $config_custom_jails = hiera_hash('fail2ban::custom_jails',undef)

  if $::fail2ban::config_dir_source {
    file { 'fail2ban.dir':
      ensure  => $::fail2ban::config_dir_ensure,
      path    => $::fail2ban::config_dir_path,
      force   => $::fail2ban::config_dir_purge,
      purge   => $::fail2ban::config_dir_purge,
      recurse => $::fail2ban::config_dir_recurse,
      source  => $::fail2ban::config_dir_source,
      notify  => $::fail2ban::config_file_notify,
      require => $::fail2ban::config_file_require,
    }
  }

  if $::fail2ban::config_file_path {
    file { 'fail2ban.conf':
      ensure  => $::fail2ban::config_file_ensure,
      path    => $::fail2ban::config_file_path,
      owner   => $::fail2ban::config_file_owner,
      group   => $::fail2ban::config_file_group,
      mode    => $::fail2ban::config_file_mode,
      source  => $::fail2ban::config_file_source,
      content => $::fail2ban::config_file_content,
      notify  => $::fail2ban::config_file_notify,
      require => $::fail2ban::config_file_require,
    }
  }

  if $config_custom_jails {
    create_resources('fail2ban::jail', $config_custom_jails)
  }

  case $::operatingsystem {
    # Not using firewalld by now
    /^(RedHat|CentOS|Scientific)$/: {
      file { '00-firewalld.conf':
        ensure  => 'absent',
        path    => "${::fail2ban::config_dir_path}/jail.d/00-firewalld.conf",
        notify  => $::fail2ban::config_file_notify,
        require => $::fail2ban::config_file_require,
      }
    }
    'Debian': {
    }
    default: {
      fail("${::operatingsystem} not supported.")
    }
  }

}
