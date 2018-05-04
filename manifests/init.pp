# == Class: fail2ban
#
class fail2ban (
  Enum['absent', 'latest', 'present', 'purged'] $package_ensure = 'present',
  String $package_name = $::fail2ban::params::package_name,
  Optional[Array[String]] $package_list = $::fail2ban::params::package_list,

  Stdlib::Absolutepath $config_dir_path = $::fail2ban::params::config_dir_path,
  Stdlib::Absolutepath $config_dir_filter_path = $::fail2ban::params::config_dir_filter_path,
  Boolean $config_dir_purge = false,
  Boolean $config_dir_recurse = true,
  Optional[String] $config_dir_source = undef,

  Stdlib::Absolutepath $config_file_path = $::fail2ban::params::config_file_path,
  String $config_file_owner = $::fail2ban::params::config_file_owner,
  String $config_file_group = $::fail2ban::params::config_file_group,
  String $config_file_mode = $::fail2ban::params::config_file_mode,
  Optional[String] $config_file_source = undef,
  Optional[String] $config_file_string = undef,
  Optional[String] $config_file_template = undef,

  String $config_file_notify = $::fail2ban::params::config_file_notify,
  String $config_file_require = $::fail2ban::params::config_file_require,

  Hash[String, Any] $config_file_hash = {},
  Hash $config_file_options_hash = {},

  Enum['running', 'stopped'] $service_ensure = 'running',
  String $service_name = $::fail2ban::params::service_name,
  Boolean $service_enable = true,

  String $action = 'action_mb',
  Integer[0] $bantime = 432000,
  String $email = "fail2ban@${::domain}",
  Array[String] $jails = ['ssh', 'ssh-ddos'],
  Integer[0] $maxretry = 3,
  Array $whitelist = ['127.0.0.1/8', '192.168.56.0/24'],
  $custom_jails = undef,
) inherits ::fail2ban::params {
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

  anchor { 'fail2ban::begin': }
  -> class { '::fail2ban::install': }
  -> class { '::fail2ban::config': }
  ~> class { '::fail2ban::service': }
  -> anchor { 'fail2ban::end': }
}
