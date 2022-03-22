# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  host.install_package('epel-release') if fact_on(host, 'osfamily') == 'RedHat'
end
