# == Define: fail2ban::define
#
define fail2ban::define (
  Stdlib::Absolutepath $config_file_path = "${fail2ban::config_dir_path}/${title}",
  String $config_file_owner = $fail2ban::config_file_owner,
  String $config_file_group = $fail2ban::config_file_group,
  String $config_file_mode = $fail2ban::config_file_mode,
  Optional[String] $config_file_source = undef,
  Optional[String] $config_file_string = undef,
  Optional[String] $config_file_template = undef,

  String $config_file_notify = $fail2ban::config_file_notify,
  String $config_file_require = $fail2ban::config_file_require,

  Hash $config_file_options_hash = $fail2ban::config_file_options_hash,
) {
  $config_file_content = extlib::default_content($config_file_string, $config_file_template)

  file { "define_${name}":
    ensure  => $fail2ban::config_file_ensure,
    path    => $config_file_path,
    owner   => $config_file_owner,
    group   => $config_file_group,
    mode    => $config_file_mode,
    source  => $config_file_source,
    content => $config_file_content,
    notify  => $config_file_notify,
    require => $config_file_require,
  }
}
