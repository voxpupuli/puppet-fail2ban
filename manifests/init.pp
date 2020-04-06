# == Class: fail2ban
#
class fail2ban (
  String[1] $package_name,
  Optional[Array[String]] $package_list,

  Stdlib::Absolutepath $config_dir_path,
  Stdlib::Absolutepath $config_dir_filter_path,

  Stdlib::Absolutepath $config_file_path,
  String[1] $config_file_owner,
  String[1] $config_file_group,
  String[1] $config_file_mode,
  String[1] $config_file_before,

  String[1] $config_file_notify,
  String[1] $config_file_require,

  String[1] $service_name,

  Enum['absent', 'latest', 'present', 'purged'] $package_ensure = 'present',

  Boolean $config_dir_purge = false,
  Boolean $config_dir_recurse = true,
  Optional[String] $config_dir_source = undef,

  Optional[String[1]] $config_file_source = undef,
  Optional[String[1]] $config_file_string = undef,
  Optional[String[1]] $config_file_template = undef,

  Hash[String[1], Any] $config_file_hash = {},
  Hash $config_file_options_hash = {},

  Enum['running', 'stopped'] $service_ensure = 'running',
  Boolean $service_enable = true,

  String[1] $action = 'action_mb',
  Integer[0] $bantime = 432000,
  String[1] $email = "fail2ban@${facts['networking']['domain']}",
  String[1] $sender = "fail2ban@${facts['networking']['fqdn']}",
  String[1] $iptables_chain = 'INPUT',
  Array[String[1]] $jails = ['ssh', 'ssh-ddos'],
  Integer[0] $maxretry = 3,
  Array $whitelist = ['127.0.0.1/8', '192.168.56.0/24'],
  Hash[String, Hash] $custom_jails = {},
  String[1] $banaction = 'iptables-multiport',
) {
  $config_file_content = extlib::default_content($config_file_string, $config_file_template)

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

  contain fail2ban::install
  contain fail2ban::config
  contain fail2ban::service

  Class['fail2ban::install']
  -> Class['fail2ban::config']
  ~> Class['fail2ban::service']
}
