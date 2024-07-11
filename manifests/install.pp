# == Class: fail2ban::install
class fail2ban::install {
  if $fail2ban::package_name {
    package { 'fail2ban':
      ensure          => $fail2ban::package_ensure,
      name            => $fail2ban::package_name,
      install_options => $fail2ban::package_install_options,
    }
  }

  if $fail2ban::package_list {
    ensure_resource('package', $fail2ban::package_list, {
        'ensure'          => $fail2ban::package_ensure,
        'install_options' => $fail2ban::package_install_options,
    })
  }
}
