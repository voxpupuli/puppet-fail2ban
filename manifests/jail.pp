# == Define: fail2ban::jail
#
define fail2ban::jail (
  $filter_includes             = undef,
  $filter_failregex            = undef,
  $filter_ignoreregex          = undef,
  $filter_additional_config    = undef,
  $enabled                     = true,
  $action                      = undef,
  $filter                      = undef,
  $logpath                     = undef,
  $maxretry                    = $fail2ban::maxtretry,
  $findtime                    = undef,
  $bantime                     = $fail2ban::bantime,
  $port                        = undef,


  $config_dir_filter_path   = $fail2ban::config_dir_filter_path,
  $config_file_owner        = undef,
  $config_file_group        = undef,
  $config_file_mode         = undef,
  $config_file_source       = undef,
  $config_file_notify       = undef,
  $config_file_require      = undef,
) {

  # Validation
  if $filter_includes { validate_string($filter_includes) }
  if $filter_failregex { validate_string($filter_failregex) }
  if $filter_ignoreregex { validate_string($filter_ignoreregex) }
  if $enabled { validate_bool($enabled) }
  if $action { validate_string($action) }
  if $filter { validate_string($filter) }
  if $logpath { validate_string($logpath) }
  else { fail('logpath required for each jail declaration') }
  if $maxretry { validate_integer($maxretry) }
  if $findtime { validate_integer($findtime) }
  if $bantime { validate_integer($bantime) }
  if $port { validate_string($port) }

  if $config_dir_filter_path { validate_absolute_path($config_dir_filter_path) }
  if $config_file_owner { validate_string($config_file_owner) }
  if $config_file_group { validate_string($config_file_group) }
  if $config_file_mode { validate_string($config_file_mode) }
  if $config_file_notify { validate_string($config_file_notify) }
  if $config_file_require { validate_string($config_file_require) }

  # Value assignment
  $_filter = pick($filter, $name)

  $_config_file_owner = pick($config_file_owner, $::fail2ban::config_file_owner)
  $_config_file_group = pick($config_file_group, $::fail2ban::config_file_group)
  $_config_file_mode = pick($config_file_mode, $::fail2ban::config_file_mode)
  $_config_file_notify = pick($config_file_notify, $::fail2ban::config_file_notify)
  $_config_file_require = pick($config_file_require, $::fail2ban::config_file_require)

  # Jail filter creation
  file { "custom_filter_${name}":
    ensure  => file,
    path    => "${config_dir_filter_path}/${name}.conf",
    content => template('fail2ban/common/custom_filter.conf.erb'),
    owner   => $_config_file_owner,
    group   => $_config_file_group,
    mode    => $_config_file_mode,
    notify  => $_config_file_notify,
    require => $_config_file_require,
  }

  # Jail creation
  file { "custom_jail_${name}":
    ensure  => file,
    path    => "${::fail2ban::params::config_dir_path}/jail.d/${name}.conf",
    content => template('fail2ban/common/custom_jail.conf.erb'),
    owner   => $_config_file_owner,
    group   => $_config_file_group,
    mode    => $_config_file_mode,
    notify  => $_config_file_notify,
    require => $_config_file_require,
  }
}
