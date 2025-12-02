# @summary Installs, configures and manages the Fail2ban service.
#
# @param package_ensure
#   Determines if the package should be installed.
#
# @param package_name
#   Determines the name of package to manage.
#
# @param package_list
#   Determines if additional packages should be managed.
#
# @param config_dir_path
#   Configuration directory path
#
# @param config_dir_purge
#   Determines if unmanaged configuration files should be removed.
#
# @param config_file_path
#   Determines if the configuration file should be managed.
#
# @param config_file_owner
#   Determines which user should own the configuration file.
#
# @param config_file_group
#   Determines which group should own the configuration file.
#
# @param config_file_mode
#   Determines the desired permissions mode of the configuration file.
#
# @param config_file_template
#   Determines which configuration file template to use.
#
# @param config_file_notify
#   Determines which service should be restarted after configuration changes.
#
# @param config_file_require
#   Determines which package a configuration file depends on.
#
# @param debian_defaults_conf_ensure
#   Determines whether the file `/etc/fail2ban/jail.d/defaults-debian.conf` should be deleted or not.
#
# @param el_firewalld_conf_ensure
#   Determines whether the file `/etc/fail2ban/jail.d/00-firewalld.conf` should be deleted or not.
#
# @param service_ensure
#   Determines if the service should be running or not.
#
# @param service_name
#   Determines the name of service to manage.
#
# @param service_enable
#   Determines if the service should be enabled at boot.
#
# @param bantime_increment
#   Increment ban time for previously banned IPs.
#
# @param bantime_rndtime
#   Maximum number of seconds to randomly add to ban time.
#
# @param bantime_maxtime
#   Maximum ban time.
#
# @param bantime_factor
#   Coefficient to increment ban time by.
#
# @param bantime_formula
#   Formula used to calculate ban time.
#
# @param bantime_multipliers
#   Alternative to formula, multiply ban time by multipliers.
#
# @param bantime_overalljails
#   Search banned IPs over all jails.
#
# @param ignoreself
#   Ignore local IP address.
#
# @param ignoreip
#   Determines which ip addresses will not be reported
#
# @param ignorecommand
#   External command to evaluate if an IP should be ignored.
#
# @param bantime
#   Determines how many time (second or hour or week) ip addresses will be banned.
#
# @param findtime
#   Interval in which max retries are evaluated.
#
# @param maxretry
#   Determines the number of failed login attempts needed to block a host.
#
# @param maxmatches
#   Number of stored matches.
#
# @param default_backend
#   Default backend in use by fail2ban for file modification.
#
# @param usedns
#   Perform DNS lookup of encountered hostnames.
#
# @param logencoding
#   Encoding of log files (ascii, utf-8...).
#
# @param enable_all_jails
#   Enable all the jails known to fail2ban.
#
# @param default_mode
#   Default mode of filters.
#
# @param default_filter
#   Default filter in use by the jails.
#
# @param destemail
#   Determines which email address should be notified about restricted hosts and suspicious logins.
#
# @param sender
#   Determines which email address should notify about restricted hosts and suspicious logins.
#
# @param mta
#   MTA in use for mailing.
#
# @param protocol
#   Default protocol.
#
# @param iptables_chain
#   Determines chain where jumps will to be added in iptables-\* actions.
#
# @param port
#   Port interval to be banned, usually to be overridden in jails.
#
# @param fail2ban_agent
#   User-agent compliant to RFC7231 Section-5.5.3
#
# @param banaction
#   Determines which action to perform when performing a global ban (not overridden in a specific jail).
#
# @param banaction_allports
#   Determines which action to perform when performing a global ban for all ports (not overridden in a specific jail).
#
# @param action
#   Choose the default action to handle banned IPs.
#
# @param jails
#   Configures defaults jails in jail.local
#
#  @example Set some [DEFAULT] parameters and enable two jails
#   class { 'fail2ban':
#     bantime  => '30m',
#     maxretry => 5,
#     jails => {
#       sshd => {
#         enabled => true,
#         bantime => '1h',
#       },
#       ssh-selinux => {
#         enabled => true,
#       },
#     },
#   }
# 
class fail2ban (
  Enum['absent', 'latest', 'present', 'purged']              $package_ensure = 'present',
  String[1]                                                  $package_name = 'fail2ban',
  Optional[Array[String]]                                    $package_list = undef,
  Stdlib::Absolutepath                                       $config_dir_path = '/etc/fail2ban',
  Boolean                                                    $config_dir_purge = false,
  Stdlib::Absolutepath                                       $config_file_path = '/etc/fail2ban/jail.local',
  String[1]                                                  $config_file_owner = 'root',
  String[1]                                                  $config_file_group = 'root',
  String[1]                                                  $config_file_mode = '0644',
  String[1]                                                  $config_file_template = 'fail2ban/jail.local.epp',
  String[1]                                                  $config_file_notify = 'Service[fail2ban]',
  String[1]                                                  $config_file_require = 'Package[fail2ban]',
  Enum['absent', 'present']                                  $debian_defaults_conf_ensure = 'present',
  Enum['absent', 'present']                                  $el_firewalld_conf_ensure = 'present',
  Enum['running', 'stopped']                                 $service_ensure = 'running',
  String[1]                                                  $service_name = 'fail2ban',
  Boolean                                                    $service_enable = true,
  # --------------------------- jails.local/[DEFAULT] -------------------------- #
  Optional[Boolean]                                          $bantime_increment = undef,
  Optional[Integer[1]]                                       $bantime_rndtime = undef,
  Optional[Integer[1]]                                       $bantime_maxtime = undef,
  Optional[Integer[1]]                                       $bantime_factor = undef,
  Optional[String[1]]                                        $bantime_formula = undef,
  Array[Integer]                                             $bantime_multipliers = [],
  Optional[Boolean]                                          $bantime_overalljails = undef,
  Optional[Boolean]                                          $ignoreself = undef,
  Optional[String[1]]                                        $ignorecommand = undef,
  Optional[Array[Fail2ban::IP]]                              $ignoreip = undef,
  Optional[Fail2ban::Time]                                   $bantime = undef,
  Optional[Fail2ban::Time]                                   $findtime = undef,
  Optional[Integer[0]]                                       $maxretry = undef,
  Optional[String[1]]                                        $maxmatches = undef,
  Optional[Enum['pyinotify', 'polling', 'systemd', 'auto']]  $default_backend = undef,
  Optional[Enum['yes', 'warn', 'no', 'raw']]                 $usedns = undef,
  Optional[String[1]]                                        $logencoding = undef,
  Optional[Boolean]                                          $enable_all_jails = undef,
  Optional[String[1]]                                        $default_mode = undef,
  Optional[String[1]]                                        $default_filter = undef,
  Optional[String[1]]                                        $destemail = undef,
  Optional[String[1]]                                        $sender = undef,
  Optional[Enum['sendmail', 'mail']]                         $mta = undef,
  Optional[Enum['tcp', 'udp']]                               $protocol = undef,
  Optional[String[1]]                                        $iptables_chain = undef,
  Optional[String[1]]                                        $port = undef,
  Optional[String[1]]                                        $fail2ban_agent = undef,
  Optional[String[1]]                                        $banaction = undef,
  Optional[String[1]]                                        $banaction_allports = undef,
  Optional[String[1]]                                        $action = undef,
  # ------------------------ jails.local/[default-jails] ----------------------- #
  Optional[Hash]                                             $jails = undef,
) {
  # Transform ignoreip array into a comma-separated string
  $ignoreip_string = if $ignoreip != undef {
    $ignoreip.join(', ')
  }
  else {
    undef
  }
  # Transform bantime_multipliers array into a space-separated string
  $bantime_multipliers_string = if $bantime_multipliers != [] {
    $bantime_multipliers.join(' ')
  }
  else {
    undef
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
