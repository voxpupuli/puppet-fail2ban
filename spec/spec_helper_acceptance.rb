require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  if fact_on(host, 'osfamily') == 'RedHat'
    host.install_package('epel-release')
    host.install_package('redhat-lsb-core')
  end
end
