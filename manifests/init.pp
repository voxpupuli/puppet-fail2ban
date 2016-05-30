# == Class: fail2ban
#
class fail2ban (
  $package_ensure           = 'present',
  $package_name             = $::fail2ban::params::package_name,
  $package_list             = $::fail2ban::params::package_list,

  $config_dir_path          = $::fail2ban::params::config_dir_path,
  $config_dir_filter_path   = $::fail2ban::params::config_dir_filter_path,
  $config_dir_purge         = false,
  $config_dir_recurse       = true,
  $config_dir_source        = undef,

  $config_file_path         = $::fail2ban::params::config_file_path,
  $config_file_owner        = $::fail2ban::params::config_file_owner,
  $config_file_group        = $::fail2ban::params::config_file_group,
  $config_file_mode         = $::fail2ban::params::config_file_mode,
  $config_file_source       = undef,
  $config_file_string       = undef,
  $config_file_template     = undef,

  $config_file_notify       = $::fail2ban::params::config_file_notify,
  $config_file_require      = $::fail2ban::params::config_file_require,

  $config_file_hash         = {},
  $config_file_options_hash = {},

  $service_ensure           = 'running',
  $service_name             = $::fail2ban::params::service_name,
  $service_enable           = true,

  $action                   = 'action_mb',
  $bantime                  = 432000,
  $email                    = "fail2ban@${::domain}",
  $jails                    = ['ssh', 'ssh-ddos'],
  $maxretry                 = 3,
  $whitelist                = ['127.0.0.1/8', '192.168.56.0/24'],
  $custom_jails             = undef,
) inherits ::fail2ban::params {
  validate_re($package_ensure, '^(absent|latest|present|purged)$')
  validate_string($package_name)
  if $package_list { validate_array($package_list) }

  validate_absolute_path($config_dir_path)
  validate_bool($config_dir_purge)
  validate_bool($config_dir_recurse)
  if $config_dir_source { validate_string($config_dir_source) }

  validate_absolute_path($config_file_path)
  validate_string($config_file_owner)
  validate_string($config_file_group)
  validate_string($config_file_mode)
  if $config_file_source { validate_string($config_file_source) }
  if $config_file_string { validate_string($config_file_string) }
  if $config_file_template { validate_string($config_file_template) }

  validate_string($config_file_notify)
  validate_string($config_file_require)

  validate_hash($config_file_hash)
  validate_hash($config_file_options_hash)

  validate_re($service_ensure, '^(running|stopped)$')
  validate_string($service_name)
  validate_bool($service_enable)

  $config_file_content = default_content($config_file_string, $config_file_template)

  if $config_file_hash {
    create_resources('fail2ban::define', $config_file_hash)
  }

  if $package_ensure == 'absent' {
    $config_dir_ensure  = 'directory'
    $config_file_ensure = 'present'
    $_service_ensure    = 'stopped'
    $_service_enable    = false
  } elsif $package_ensure == 'purged' {
    $config_dir_ensure  = 'absent'
    $config_file_ensure = 'absent'
    $_service_ensure    = 'stopped'
    $_service_enable    = false
  } else {
    $config_dir_ensure  = 'directory'
    $config_file_ensure = 'present'
    $_service_ensure    = $service_ensure
    $_service_enable    = $service_enable
  }

  validate_re($config_dir_ensure, '^(absent|directory)$')
  validate_re($config_file_ensure, '^(absent|present)$')

  anchor { 'fail2ban::begin': } ->
  class { '::fail2ban::install': } ->
  class { '::fail2ban::config': } ~>
  class { '::fail2ban::service': } ->
  anchor { 'fail2ban::end': }
}
