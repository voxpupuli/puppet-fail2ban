# == Define: fail2ban::jail
#
define fail2ban::jail (
  Enum[absent|file] $ensure = 'file',
  Boolean $enabled = true,

  Enum[absent|file] $filter_ensure = 'file',
  Boolean $filter_manage = true,
  Optional[String] $filter_includes = undef,
  Optional[String] $filter_failregex = undef,
  Optional[String] $filter_ignoreregex = undef,
  Optional[Integer] $filter_maxlines = undef,
  Optional[String] $filter_datepattern = undef,
  $filter_additional_config = undef,
  Optional[String] $action = undef,
  String $filter = $title,
  String $logpath = undef,
  Integer $maxretry = $fail2ban::maxretry,
  Optional[Integer] $findtime = undef,
  Integer $bantime = $fail2ban::bantime,
  Optional[String] $port = undef,
  Optional[String] $backend = undef,
  Optional[String[1]] $journalmatch = undef,
  Array[Stdlib::IP::Address] $ignoreip = [],

  Stdlib::Absolutepath $config_dir_filter_path = $fail2ban::config_dir_filter_path,
  Optional[String] $config_file_owner = $fail2ban::config_file_owner,
  Optional[String] $config_file_group = $fail2ban::config_file_group,
  Optional[String] $config_file_mode = $fail2ban::config_file_mode,
  Optional[String] $config_file_source = $fail2ban::config_file_source,
  Optional[String] $config_file_notify = $fail2ban::config_file_notify,
  Optional[String] $config_file_require = $fail2ban::config_file_require,
) {
  if $filter_manage {
    # Jail filter creation
    file { "custom_filter_${name}":
      ensure  => $filter_ensure,
      path    => "${config_dir_filter_path}/${name}.conf",
      content => epp('fail2ban/common/custom_filter.conf.epp',
        {
          findtime                 => $findtime,
          filter_includes          => $filter_includes,
          filter_additional_config => $filter_additional_config,
          filter_failregex         => $filter_failregex,
          filter_ignoreregex       => $filter_ignoreregex,
          filter_maxlines          => $filter_maxlines,
          filter_datepattern       => $filter_datepattern,
          journalmatch             => $journalmatch,
        }
      ),
      owner   => $config_file_owner,
      group   => $config_file_group,
      mode    => $config_file_mode,
      notify  => $config_file_notify,
      require => $config_file_require,
    }
  }

  # Jail creation
  file { "custom_jail_${name}":
    ensure  => $ensure,
    path    => "${fail2ban::config_dir_path}/jail.d/${name}.conf",
    content => epp('fail2ban/common/custom_jail.conf.epp',
      {
        name         => $name,
        enabled      => $enabled,
        action       => $action,
        filter       => $filter,
        logpath      => $logpath,
        maxretry     => $maxretry,
        findtime     => $findtime,
        bantime      => $bantime,
        port         => $port,
        backend      => $backend,
        journalmatch => $journalmatch,
        ignoreip     => $ignoreip,
      }
    ),
    owner   => $config_file_owner,
    group   => $config_file_group,
    mode    => $config_file_mode,
    notify  => $config_file_notify,
    require => $config_file_require,
  }
}
