# == Define: fail2ban::action
#
define fail2ban::action (
  String $actionban = undef,
  String $actionunban = undef,

  Optional[String] $config_file_owner = $fail2ban::config_file_owner,
  Optional[String] $config_file_group = $fail2ban::config_file_group,
  Optional[String] $config_file_mode = $fail2ban::config_file_mode,
  Optional[String] $config_file_source = $fail2ban::config_file_source,
  Optional[String] $config_file_notify = $fail2ban::config_file_notify,
  Optional[String] $config_file_require = $fail2ban::config_file_require,
) {

  file { "custom_action_${name}":
    ensure  => file,
    path    => "${::fail2ban::params::config_dir_path}/action.d/${name}.conf",
    content => epp('fail2ban/common/custom_action.conf.epp',
      {
        name        => $name,
        actionban   => $actionban,
        actionunban => $actionunban
      }
    ),
    owner   => $config_file_owner,
    group   => $config_file_group,
    mode    => $config_file_mode,
    notify  => $config_file_notify,
    require => $config_file_require
  }
}
