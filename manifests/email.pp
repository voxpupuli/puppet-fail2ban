define fail2ban::email($email, $whitelists) {
  file { $name:
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    alias   => 'jail.conf',
    content => template("fail2ban/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb"),
    notify  => Service['fail2ban'],
    require => Package['fail2ban'],
  }
}