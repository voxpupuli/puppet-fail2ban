# == Class: fail2ban
#
class fail2ban (
  $package_ensure           = 'present',
  $package_name             = undef,
  $package_list             = undef,

  $config_dir_path          = undef,
  $config_dir_purge         = false,
  $config_dir_recurse       = true,
  $config_dir_source        = undef,

  $config_file_path         = undef,
  $config_file_owner        = undef,
  $config_file_group        = undef,
  $config_file_mode         = undef,
  $config_file_source       = undef,
  $config_file_string       = undef,
  $config_file_template     = undef,

  $config_file_notify       = undef,
  $config_file_require      = undef,

  $config_file_hash         = {},
  $config_file_options_hash = {},

  $service_ensure           = 'running',
  $service_name             = undef,
  $service_enable           = true,

  $action                   = 'action_mb',
  $bantime                  = 432000,
  $email                    = "fail2ban@${::domain}",
  $jails                    = ['ssh', 'ssh-ddos'],
  $maxretry                 = 3,
  $whitelist                = ['127.0.0.1/8', '192.168.56.0/24'],
) {

  # variable preparations
  case $::osfamily {
    'Debian': {
      $package_name_default        = 'fail2ban'
      $package_list_default        = undef
      $config_dir_path_default     = '/etc/fail2ban'
      $config_file_path_default    = '/etc/fail2ban/jail.conf'
      $config_file_owner_default   = 'root'
      $config_file_group_default   = 'root'
      $config_file_mode_default    = '0644'
      $config_file_notify_default  = 'Service[fail2ban]'
      $config_file_require_default = 'Package[fail2ban]'
      $service_name_default        = 'fail2ban'
    }
    'RedHat': {
      $package_name_default        = 'fail2ban'
      $package_list_default        = undef
      $config_dir_path_default     = '/etc/fail2ban'
      $config_file_path_default    = '/etc/fail2ban/jail.conf'
      $config_file_owner_default   = 'root'
      $config_file_group_default   = 'root'
      $config_file_mode_default    = '0644'
      $config_file_notify_default  = 'Service[fail2ban]'
      $config_file_require_default = 'Package[fail2ban]'
      $service_name_default        = 'fail2ban'
    }
    default: {
      fail("${::operatingsystem} not supported.")
    }
  }

  $package_name_real = $package_name ? {
    undef   => $package_name_default,
    default => $package_name,
  }

  $package_list_real = $package_list ? {
    undef   => $package_list_default,
    default => $package_list,
  }

  $config_dir_path_real = $config_dir_path ? {
    undef   => $config_dir_path_default,
    default => $config_dir_path,
  }

  $config_file_path_real = $config_file_path ? {
    undef   => $config_file_path_default,
    default => $config_file_path,
  }

  $config_file_owner_real = $config_file_owner ? {
    undef   => $config_file_owner_default,
    default => $config_file_owner,
  }

  $config_file_group_real = $config_file_group ? {
    undef   => $config_file_group_default,
    default => $config_file_group,
  }

  $config_file_mode_real = $config_file_mode ? {
    undef   => $config_file_mode_default,
    default => $config_file_mode,
  }

  $config_file_notify_real = $config_file_notify ? {
    undef   => $config_file_notify_default,
    default => $config_file_notify,
  }

  $config_file_require_real = $config_file_require ? {
    undef   => $config_file_require_default,
    default => $config_file_require,
  }

  $service_name_real = $service_name ? {
    undef   => $service_name_default,
    default => $service_name,
  }

  # variable validations
  validate_re($package_ensure, '^(absent|latest|present|purged)$')
  validate_string($package_name_real)
  if $package_list_real { validate_array($package_list_real) }

  validate_absolute_path($config_dir_path_real)
  validate_bool($config_dir_purge)
  validate_bool($config_dir_recurse)
  if $config_dir_source { validate_string($config_dir_source) }

  validate_absolute_path($config_file_path_real)
  validate_string($config_file_owner_real)
  validate_string($config_file_group_real)
  validate_string($config_file_mode_real)
  if $config_file_source { validate_string($config_file_source) }
  if $config_file_string { validate_string($config_file_string) }
  if $config_file_template { validate_string($config_file_template) }

  validate_string($config_file_notify_real)
  validate_string($config_file_require_real)

  validate_hash($config_file_hash)
  validate_hash($config_file_options_hash)

  validate_re($service_ensure, '^(running|stopped)$')
  validate_string($service_name_real)
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
