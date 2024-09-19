# @summary Installs, configures and manages the Fail2ban service.
#
# This module installs, configures and manages the Fail2ban service.
# Main class, includes all other classes.
#
# @param package_ensure Determines if the package should be installed.
# @param package_name Determines the name of package to manage.
# @param package_list Determines if additional packages should be managed.
# @param config_dir_path Determines if the configuration directory should be managed.
# @param config_dir_purge Determines if unmanaged configuration files should be removed.
# @param config_dir_recurse Determines if the configuration directory should be recursively managed.
# @param config_dir_source Determines the source of a configuration directory.
# @param config_file_path Determines if the configuration file should be managed.
# @param config_file_owner Determines which user should own the configuration file.
# @param config_file_group Determines which group should own the configuration file.
# @param config_file_mode Determines the desired permissions mode of the configuration file.
# @param config_file_source Determines the source of a configuration file.
# @param config_file_string Determines the content of a configuration file.
# @param config_file_template Determines the content of a configuration file.
# @param config_file_notify Determines if the service should be restarted after configuration changes.
# @param config_file_require Determines which package a configuration file depends on.
# @param config_file_hash Determines which configuration files should be managed via `fail2ban::define`.
# @param config_file_options_hash Determines which parameters should be passed to an ERB template.
# @param manage_defaults Determines whether the file `/etc/fail2ban/jail.d/defaults-debian.conf` should be deleted or not.
# @param manage_firewalld Determines whether the file `/etc/fail2ban/jail.d/00-firewalld.conf` should be deleted or not.
# @param service_ensure Determines if the service should be running or not.
# @param service_name Determines the name of service to manage.
# @param service_enable Determines if the service should be enabled at boot.
# @param action Determines how banned ip addresses should be reported.
# @param bantime Determines how many time (second or hour or week) ip addresses will be banned.
# @param email Determines which email address should be notified about restricted hosts and suspicious logins.
# @param sender Determines which email address should notify about restricted hosts and suspicious logins.
# @param iptables_chain Determines chain where jumps will to be added in iptables-\* actions.
# @param jails Determines which services should be protected by Fail2ban.
# @param maxretry Determines the number of failed login attempts needed to block a host.
# @param whitelist Determines which ip addresses will not be reported
# @param custom_jails Determines which custom jails should be included
# @param banaction Determines which action to perform when performing a global ban (not overridden in a specific jail).
#
class fail2ban (
  String[1] $config_file_before,

  Enum['absent', 'latest', 'present', 'purged'] $package_ensure = 'present',
  String[1] $package_name = 'fail2ban',
  Optional[Array[String]] $package_list = undef,

  Stdlib::Absolutepath $config_dir_path = '/etc/fail2ban',
  Stdlib::Absolutepath $config_dir_filter_path = '/etc/fail2ban/filter.d',
  Boolean $config_dir_purge = false,
  Boolean $config_dir_recurse = true,
  Optional[String] $config_dir_source = undef,

  Stdlib::Absolutepath $config_file_path = '/etc/fail2ban/jail.conf',
  String[1] $config_file_owner = 'root',
  String[1] $config_file_group = 'root',
  String[1] $config_file_mode = '0644',
  Optional[String[1]] $config_file_source = undef,
  Optional[String[1]] $config_file_string = undef,
  Optional[String[1]] $config_file_template = undef,

  String[1] $config_file_notify = 'Service[fail2ban]',
  String[1] $config_file_require = 'Package[fail2ban]',

  Hash[String[1], Any] $config_file_hash = {},
  Hash $config_file_options_hash = {},

  Enum['absent', 'present'] $manage_defaults = 'absent',
  Enum['absent', 'present'] $manage_firewalld = 'absent',

  Enum['running', 'stopped'] $service_ensure = 'running',
  String[1] $service_name = 'fail2ban',
  Boolean $service_enable = true,

  String[1] $action = 'action_mb',
  Fail2ban::Time $bantime = 432000,
  String[1] $email = "fail2ban@${facts['networking']['domain']}",
  String[1] $sender = "fail2ban@${facts['networking']['fqdn']}",
  String[1] $iptables_chain = 'INPUT',
  Array[String[1]] $jails = ['ssh', 'ssh-ddos'],
  Integer[0] $maxretry = 3,
  Enum['pyinotify', 'gamin', 'polling', 'systemd', 'auto'] $default_backend = 'auto',
  Array $whitelist = ['127.0.0.1/8', '192.168.56.0/24'],
  Hash[String, Hash] $custom_jails = {},
  String[1] $banaction = 'iptables-multiport',
  Hash $sendmail_config = {},
  Hash $sendmail_actions = {},
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
