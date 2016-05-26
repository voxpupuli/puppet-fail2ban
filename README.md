# fail2ban

[![Build Status](https://travis-ci.org/dhoppe/puppet-fail2ban.png?branch=master)](https://travis-ci.org/dhoppe/puppet-fail2ban)
[![Puppet Forge](https://img.shields.io/puppetforge/v/dhoppe/fail2ban.svg)](https://forge.puppetlabs.com/dhoppe/fail2ban)
[![Puppet Forge](https://img.shields.io/puppetforge/dt/dhoppe/fail2ban.svg)](https://forge.puppetlabs.com/dhoppe/fail2ban)
[![Puppet Forge](https://img.shields.io/puppetforge/mc/dhoppe.svg)](https://forge.puppetlabs.com/dhoppe)
[![Puppet Forge](https://img.shields.io/puppetforge/rc/dhoppe.svg)](https://forge.puppetlabs.com/dhoppe)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with fail2ban](#setup)
    * [What fail2ban affects](#what-fail2ban-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with fail2ban](#beginning-with-fail2ban)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Pre-defined jails available](#pre-defined-jails-available)
8. [Development - Guide for contributing to the module](#development)

## Overview

This module installs, configures and manages the Fail2ban service.

## Module Description

This module handles installing, configuring and running Fail2ban across a range of operating systems and distributions.

## Setup

### What fail2ban affects

* fail2ban package.
* fail2ban configuration file.
* fail2ban service.

### Setup Requirements

* Puppet >= 3.0
* Facter >= 1.6
* [Stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib)

### Beginning with fail2ban

Install fail2ban with the default parameters ***(No configuration files will be changed)***.

```puppet
    class { 'fail2ban': }
```

Install fail2ban with the recommended parameters.

```puppet
    class { 'fail2ban':
      config_file_template => "fail2ban/${::osfamily}/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb",
    }
```

### Config file template
You'll find an example on examples folder for each operating system.
Previous example show how to enable config for Debian operating system, using ${::osfamily}/${::lsbdistcodename} fact.

RedHat/CentOS requires a totally different configuration file. To add it, instead of the one using ${::osfamily}/${::lsbdistcodename} fact, use the following one:

```puppet
  class { 'fail2ban':
    config_file_template => "fail2ban/%{::osfamily}/etc/fail2ban/jail.conf.erb"
  }
```

Or using Hiera:

```hiera
fail2ban::config_file_template: "fail2ban/%{::osfamily}/etc/fail2ban/jail.conf.erb"
```

## Usage

Update the fail2ban package.

```puppet
    class { 'fail2ban':
      package_ensure => 'latest',
    }
```

Remove the fail2ban package.

```puppet
    class { 'fail2ban':
      package_ensure => 'absent',
    }
```

Purge the fail2ban package ***(All configuration files will be removed)***.

```puppet
    class { 'fail2ban':
      package_ensure => 'purged',
    }
```

Deploy the configuration files from source directory.

```puppet
    class { 'fail2ban':
      config_dir_source => "puppet:///modules/fail2ban/${::osfamily}/${::lsbdistcodename}/etc/fail2ban",
    }
```

Deploy the configuration files from source directory ***(Unmanaged configuration files will be removed)***.

```puppet
    class { 'fail2ban':
      config_dir_purge  => true,
      config_dir_source => "puppet:///modules/fail2ban/${::osfamily}/${::lsbdistcodename}/etc/fail2ban",
    }
```

Deploy the configuration file from source.

```puppet
    class { 'fail2ban':
      config_file_source => "puppet:///modules/fail2ban/${::osfamily}/${::lsbdistcodename}/etc/fail2ban/jail.conf",
    }
```

Deploy the configuration file from string.

```puppet
    class { 'fail2ban':
      config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
    }
```

Deploy the configuration file from template.

```puppet
    class { 'fail2ban':
      config_file_template => "fail2ban/${::osfamily}/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb",
    }
```

Deploy the configuration file from custom template ***(Additional parameters can be defined)***.

```puppet
    class { 'fail2ban':
      config_file_template     => "fail2ban/${::osfamily}/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb",
      config_file_options_hash => {
        'key' => 'value',
      },
    }
```

Deploy additional configuration files from source, string or template.

```puppet
    class { 'fail2ban':
      config_file_hash => {
        'jail.2nd.conf' => {
          config_file_path   => '/etc/fail2ban/jail.2nd.conf',
          config_file_source => "puppet:///modules/fail2ban/${::osfamily}/${::lsbdistcodename}/etc/fail2ban/jail.2nd.conf",
        },
        'jail.3rd.conf' => {
          config_file_path   => '/etc/fail2ban/jail.3rd.conf',
          config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
        },
        'jail.4th.conf' => {
          config_file_path     => '/etc/fail2ban/jail.4th.conf',
          config_file_template => "fail2ban/${::osfamily}/${::lsbdistcodename}/etc/fail2ban/jail.4th.conf.erb",
        },
      },
    }
```

Disable the fail2ban service.

```puppet
    class { 'fail2ban':
      service_ensure => 'stopped',
    }
```

## Reference

### Classes

#### Public Classes

* fail2ban: Main class, includes all other classes.

#### Private Classes

* fail2ban::install: Handles the packages.
* fail2ban::config: Handles the configuration file.
* fail2ban::service: Handles the service.

### Parameters

#### `package_ensure`

Determines if the package should be installed. Valid values are 'present', 'latest', 'absent' and 'purged'. Defaults to 'present'.

#### `package_name`

Determines the name of package to manage. Defaults to 'fail2ban'.

#### `package_list`

Determines if additional packages should be managed. Defaults to 'undef'.

#### `config_dir_ensure`

Determines if the configuration directory should be present. Valid values are 'absent' and 'directory'. Defaults to 'directory'.

#### `config_dir_path`

Determines if the configuration directory should be managed. Defaults to '/etc/fail2ban'

#### `config_dir_purge`

Determines if unmanaged configuration files should be removed. Valid values are 'true' and 'false'. Defaults to 'false'.

#### `config_dir_recurse`

Determines if the configuration directory should be recursively managed. Valid values are 'true' and 'false'. Defaults to 'true'.

#### `config_dir_source`

Determines the source of a configuration directory. Defaults to 'undef'.

#### `config_file_ensure`

Determines if the configuration file should be present. Valid values are 'absent' and 'present'. Defaults to 'present'.

#### `config_file_path`

Determines if the configuration file should be managed. Defaults to '/etc/fail2ban/jail.conf'

#### `config_file_owner`

Determines which user should own the configuration file. Defaults to 'root'.

#### `config_file_group`

Determines which group should own the configuration file. Defaults to 'root'.

#### `config_file_mode`

Determines the desired permissions mode of the configuration file. Defaults to '0644'.

#### `config_file_source`

Determines the source of a configuration file. Defaults to 'undef'.

#### `config_file_string`

Determines the content of a configuration file. Defaults to 'undef'.

#### `config_file_template`

Determines the content of a configuration file. Defaults to 'undef'.

#### `config_file_notify`

Determines if the service should be restarted after configuration changes. Defaults to 'Service[fail2ban]'.

#### `config_file_require`

Determines which package a configuration file depends on. Defaults to 'Package[fail2ban]'.

#### `config_file_hash`

Determines which configuration files should be managed via `fail2ban::define`. Defaults to '{}'.

#### `config_file_options_hash`

Determines which parameters should be passed to an ERB template. Defaults to '{}'.

#### `service_ensure`

Determines if the service should be running or not. Valid values are 'running' and 'stopped'. Defaults to 'running'.

#### `service_name`

Determines the name of service to manage. Defaults to 'fail2ban'.

#### `service_enable`

Determines if the service should be enabled at boot. Valid values are 'true' and 'false'. Defaults to 'true'.

#### `action`

Determines how banned ip addresses should be reported. Defaults to 'action_mb'.

#### `bantime`

Determines how many seconds ip addresses will be banned. Defaults to '432000'.

#### `email`

Determines which email address should be notified about restricted hosts and suspicious logins. Defaults to "fail2ban@${::domain}".

#### `jails`

Determines which services should be protected by Fail2ban. Defaults to '['ssh', 'ssh-ddos']'.

#### `maxretry`

Determines the number of failed login attempts needed to block a host. Defaults to '3'.

#### `whitelist`

Determines which ip addresses will not be reported. Defaults to '['127.0.0.1/8', '192.168.56.0/24']'.

#### `additional_jails`

Enables additional jails (and its filters) such as:
- nginx-wp-login
- nginx-login
- nginx-badbots
- nginx-noscript
- nginx-proxy

## Pre-defined jails available
### RedHat osfamily:
* 3proxy
* apache-auth
* apache-badbots
* apache-botsearch
* apache-fakegooglebot
* apache-modsecurity
* apache-nohome
* apache-noscript
* apache-overflows
* apache-shellshock
* assp
* asterisk
* counter-strike
* courier-auth
* courier-smtp
* cyrus-imap
* directadmin
* dovecot
* dropbear
* drupal-auth
* ejabberd-auth
* exim
* exim-spam
* freeswitch
* froxlor-auth
* groupoffice
* gssftpd
* guacamole
* horde
* kerio
* lighttpd-auth
* monit
* mysqld-auth
* nagios
* named-refused
* nginx-botsearch
* nginx-http-auth
* nsd
* openwebmail
* oracleims
* pam-generic
* pass2allow-ftp
* perdition
* php-url-fopen
* portsentry
* postfix
* postfix-rbl
* postfix-sasl
* proftpd
* pure-ftpd
* qmail-rbl
* recidive
* roundcube-auth
* selinux-ssh
* sendmail-auth
* sendmail-reject
* sieve
* sogo-auth
* solid-pop3d
* squid
* squirrelmail
* sshd
* sshd-ddos
* stunnel
* suhosin
* tine20
* uwimap-auth
* vsftpd
* webmin-auth
* wuftpd
* xinetd-fail

### Debian osfamily:
* apache
* apache-modsecurity
* apache-multiport
* apache-nohome
* apache-noscript
* apache-overflows
* asterisk-tcp
* asterisk-udp
* courierauth
* couriersmtp
* dovecot
* dropbear
* ejabberd-auth
* freeswitch
* lighttpd-auth
* lighttpd-fastcgi
* mysqld-auth
* nagios
* named-refused-tcp
* nginx-http-auth
* pam-generic
* php-url-fopen
* postfix
* proftpd
* pure-ftpd
* recidive
* roundcube-auth
* sasl
* sogo-auth
* ssh
* ssh-blocklist
* ssh-ddos
* ssh-iptables-ipset4
* ssh-iptables-ipset6
* ssh-route
* vsftpd
* wuftpd
* xinetd-fail

## Limitations

This module has been tested on:

* Debian 6/7/8
* Ubuntu 12.04/14.04
* CentOS 7

## Development

### Bug Report

If you find a bug, have trouble following the documentation or have a question about this module - please create an issue.

### Pull Request

If you are able to patch the bug or add the feature yourself - please make a pull request.

### Contributors

The list of contributors can be found at: [https://github.com/dhoppe/puppet-fail2ban/graphs/contributors](https://github.com/dhoppe/puppet-fail2ban/graphs/contributors)
