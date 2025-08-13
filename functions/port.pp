# See https://puppet.com/docs/puppet/latest/lang_write_functions_in_puppet.html
# for more information on native puppet functions.
#
# Looks up fail2ban::jails_config.{namespace} for port configuration
#
# @param config_key
# @param default_port
# @return actual config
function fail2ban::port(String[1] $config_key, Fail2ban::Port $default_port) >> String {
  $needle = "fail2ban::jails_config.${config_key}.port"
  $result = lookup($needle, undef, undef, $default_port)

  case $result {
    String : { $result }
    Integer : { String($result) }
    Array,Tuple : { join($result, ',') }
    default : { raise(Puppet::ParseError, "Unsupported type in lookup result: ${result}.class") }
  }
}
