class fail2ban::params {
  case $::lsbdistcodename {
    'squeeze', 'natty': {
      $email     = hiera('email')
      $whitelist = hiera('whitelist')
    }
    default: {
      fail("Module ${module_name} does not support ${::lsbdistcodename}")
    }
  }
}
