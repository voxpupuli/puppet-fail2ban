# @summary Create a .local jail in jail.d
#
# @param jail_ensure
#    Removes the jail if set to 'absent'
# @param jail_name
#   Name of the jail, without .local
#
# @param jail_content
#   Content of the jail, each section is a sub-hash
#
# @example Create jail.d/nginx-wp-login.local
#   fail2ban::jail { 'nginx-wp-login':
#     jail_name    => 'nginx-wp-login',
#     jail_content => {
#       'nginx-wp-login' => {
#         'jail_failregex' => '<HOST>.*] "POST /wp-login.php',
#         'port'           => 'http,https',
#         'logpath'        => '/var/log/nginx/access.log',
#       },
#     },
#   }
#
define fail2ban::jail (
  Enum['present', 'absent'] $jail_ensure  = 'present',
  Hash                      $jail_content = {},
  Optional[String[1]]       $jail_name = undef,
) {
  file { $jail_name:
    ensure  => $jail_ensure,
    path    => "${fail2ban::config_dir_path}/jail.d/${jail_name}.local",
    content => epp('fail2ban/jail_d.local.epp', { 'jail_content' => $jail_content }),
    owner   => $fail2ban::config_file_owner,
    group   => $fail2ban::config_file_group,
    mode    => $fail2ban::config_file_mode,
    notify  => $fail2ban::config_file_notify,
    require => $fail2ban::config_file_require,
  }
}
