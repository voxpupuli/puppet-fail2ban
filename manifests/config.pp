# == Class: fail2ban::config
#
class fail2ban::config {
  if $fail2ban::config_dir_source {
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
}
