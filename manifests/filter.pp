# @summary Create a .local filter in filter.d
#
# @param filter_ensure
#    Removes the filter if set to 'absent'
# @param filter_name
#   Name of the filter, without .local
#
# @param filter_content
#   Content of the filter, each section is a sub-hash
#
# @example Create filter.d/common.local
#   fail2ban::filter { 'common':
#     filter_name    => 'common',
#     filter_content => {
#       'DEFAULT' => {
#         'logtype' => 'short',
#        },
#      },
#     }
#
define fail2ban::filter (
  Enum['present', 'absent'] $filter_ensure  = 'present',
  Hash                      $filter_content = {},
  Optional[String[1]]       $filter_name = undef,
) {
  file { $filter_name:
    ensure  => $filter_ensure,
    path    => "${fail2ban::config_dir_path}/filter.d/${filter_name}.local",
    content => epp('fail2ban/filter.local.epp', { 'filter_content' => $filter_content }),
    owner   => $fail2ban::config_file_owner,
    group   => $fail2ban::config_file_group,
    mode    => $fail2ban::config_file_mode,
    notify  => $fail2ban::config_file_notify,
    require => $fail2ban::config_file_require,
  }
}
