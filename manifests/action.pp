# @summary Create a .local action in action.d
#
# @param action_ensure
#    Removes the action if set to 'absent'
# @param action_name
#   Name of the action, without .local
#
# @param action_content
#   Content of the action, each section is a sub-hash
#
# @example Override action.d/abuseipdb.conf
#   fail2ban::action { 'abuseipdb':
#     action_name => 'abuseipdb',
#     action_content => {
#       'Definition' => {
#         norestored => '0',
#       },
#       'Init' => {
#         abuseipdb_apikey => 'my-very-secret-api-key',
#       },
#     },
#   }
#
define fail2ban::action (
  Enum['present', 'absent'] $action_ensure  = 'present',
  Hash                      $action_content = {},
  Optional[String[1]]       $action_name = undef,
) {
  file { $action_name:
    ensure  => $action_ensure,
    path    => "${fail2ban::config_dir_path}/action.d/${action_name}.local",
    content => epp('fail2ban/action.local.epp', { 'action_content' => $action_content }),
    owner   => $fail2ban::config_file_owner,
    group   => $fail2ban::config_file_group,
    mode    => $fail2ban::config_file_mode,
    notify  => $fail2ban::config_file_notify,
    require => $fail2ban::config_file_require,
  }
}
