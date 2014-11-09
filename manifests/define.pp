# == Define: fail2ban::define
#
define fail2ban::define (
  $config_file_path         = undef,
  $config_file_owner        = undef,
  $config_file_group        = undef,
  $config_file_mode         = undef,
  $config_file_source       = undef,
  $config_file_string       = undef,
  $config_file_template     = undef,

  $config_file_notify       = undef,
  $config_file_require      = undef,

  $config_file_options_hash = $::fail2ban::config_file_options_hash,
) {
  if $config_file_path { validate_absolute_path($config_file_path) }
  if $config_file_owner { validate_string($config_file_owner) }
  if $config_file_group { validate_string($config_file_group) }
  if $config_file_mode { validate_string($config_file_mode) }
  if $config_file_source { validate_string($config_file_source) }
  if $config_file_string { validate_string($config_file_string) }
  if $config_file_template { validate_string($config_file_template) }

  if $config_file_notify { validate_string($config_file_notify) }
  if $config_file_require { validate_string($config_file_require) }

  $_config_file_path  = pick($config_file_path, "${::fail2ban::config_dir_path}/${name}")
  $_config_file_owner = pick($config_file_owner, $::fail2ban::config_file_owner)
  $_config_file_group = pick($config_file_group, $::fail2ban::config_file_group)
  $_config_file_mode = pick($config_file_mode, $::fail2ban::config_file_mode)
  $config_file_content = default_content($config_file_string, $config_file_template)

  $_config_file_notify = pick($config_file_notify, $::fail2ban::config_file_notify)
  $_config_file_require = pick($config_file_require, $::fail2ban::config_file_require)

  file { "define_${name}":
    ensure  => $::fail2ban::config_file_ensure,
    path    => $_config_file_path,
    owner   => $_config_file_owner,
    group   => $_config_file_group,
    mode    => $_config_file_mode,
    source  => $config_file_source,
    content => $config_file_content,
    notify  => $_config_file_notify,
    require => $_config_file_require,
  }
}
