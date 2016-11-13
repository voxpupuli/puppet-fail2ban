# == Class: fail2ban::config
#
class fail2ban::config {
  if $::fail2ban::config_dir_source {
    file { 'fail2ban.dir':
      ensure  => $::fail2ban::config_dir_ensure,
      path    => $::fail2ban::config_dir_path_real,
      force   => $::fail2ban::config_dir_purge,
      purge   => $::fail2ban::config_dir_purge,
      recurse => $::fail2ban::config_dir_recurse,
      source  => $::fail2ban::config_dir_source,
      notify  => $::fail2ban::config_file_notify_real,
      require => $::fail2ban::config_file_require_real,
    }
  }

  if $::fail2ban::config_file_path_real {
    file { 'fail2ban.conf':
      ensure  => $::fail2ban::config_file_ensure,
      path    => $::fail2ban::config_file_path_real,
      owner   => $::fail2ban::config_file_owner_real,
      group   => $::fail2ban::config_file_group_real,
      mode    => $::fail2ban::config_file_mode_real,
      source  => $::fail2ban::config_file_source,
      content => $::fail2ban::config_file_content,
      notify  => $::fail2ban::config_file_notify_real,
      require => $::fail2ban::config_file_require_real,
    }
  }

  if getvar('::lsbdistcodename') == 'xenial' {
    file { 'defaults-debian.conf':
      ensure  => absent,
      path    => "${::fail2ban::config_dir_path}/jail.d/defaults-debian.conf",
      require => $::fail2ban::config_file_require,
    }
  }
}
