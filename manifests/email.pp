define fail2ban::email($email = false, $whitelist = false) {
  $t_email = $email ? {
    false   => 'root',
    default => $email,
  }

  $t_whitelist = $whitelist ? {
    false   => ['127.0.0.1'],
    default => $whitelist,
  }

  file { $name:
    owner   => root,
    group   => root,
    mode    => '0644',
    alias   => 'jail.conf',
    content => template("fail2ban/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb"),
    notify  => Service['fail2ban'],
    require => Package['fail2ban'],
  }
}