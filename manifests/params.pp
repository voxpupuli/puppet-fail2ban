class fail2ban::params {
  case $::lsbdistcodename {
    'lenny', 'squeeze', 'maverick', 'natty': {
      $email     = hiera('email')
      $whitelist = hiera('whitelist')
    }
    default: {
      fail("Module ${module_name} does not support ${::lsbdistcodename}")
    }
  }
}