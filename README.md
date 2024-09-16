# fail2ban

[![Build Status](https://travis-ci.org/voxpupuli/puppet-fail2ban.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-fail2ban)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-fail2ban/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-fail2ban)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/fail2ban.svg)](https://forge.puppetlabs.com/puppet/fail2ban)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/fail2ban.svg)](https://forge.puppetlabs.com/puppet/fail2ban)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/fail2ban.svg)](https://forge.puppetlabs.com/puppet/fail2ban)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/fail2ban.svg)](https://forge.puppetlabs.com/puppet/fail2ban)

## Table of Contents

1. [Overview](#overview)
1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with fail2ban](#setup)
    * [What fail2ban affects](#what-fail2ban-affects)
    * [Beginning with fail2ban](#beginning-with-fail2ban)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Jails available](#jails-available)
    * [Pre-defined jails](#pre-defined-jails)
    * [Custom jails](#custom-jails)
1. [Development - Guide for contributing to the module](#development)

## Overview

This module installs, configures and manages the Fail2ban service.

## Module Description

This module handles installing, configuring and running Fail2ban across a range of
operating systems and distributions.

## Setup

### What fail2ban affects

* fail2ban package.
* fail2ban configuration file.
* fail2ban service.


### Beginning with fail2ban

Install and configure `fail2ban`:

```puppet
    class { 'fail2ban': }
```

### Config file template

You can also manually specify a different configuration template. To do it, use
your desired configuration template (e.g. if your template is in your local profile):

```puppet
  class { 'fail2ban':
    config_file_template => "profile/fail2ban/etc/fail2ban/jail.conf.epp"
  }
```

Or using Hiera:

```hiera
fail2ban::config_file_template: "profile/fail2ban/etc/fail2ban/jail.conf.epp"
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
      config_dir_source => "puppet:///modules/profile/fail2ban/etc/fail2ban",
    }
```

Deploy the configuration files from source directory ***(Unmanaged configuration
files will be removed)***.

```puppet
    class { 'fail2ban':
      config_dir_purge  => true,
      config_dir_source => "puppet:///modules/profile/fail2ban/etc/fail2ban",
    }
```

Deploy the configuration file from source.

```puppet
    class { 'fail2ban':
      config_file_source => "puppet:///modules/profile/fail2ban/etc/fail2ban/jail.conf",
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
      config_file_template => "profile/fail2ban/etc/fail2ban/jail.conf.epp",
    }
```

Deploy the configuration file from custom template ***(Additional parameters can
be defined)***.

```puppet
    class { 'fail2ban':
      config_file_template     => "profile/fail2ban/etc/fail2ban/jail.conf.epp",
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
          config_file_source => "puppet:///modules/profile/fail2ban/etc/fail2ban/jail.2nd.conf",
        },
        'jail.3rd.conf' => {
          config_file_path   => '/etc/fail2ban/jail.3rd.conf',
          config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
        },
        'jail.4th.conf' => {
          config_file_path     => '/etc/fail2ban/jail.4th.conf',
          config_file_template => "profile/fail2ban/etc/fail2ban/jail.4th.conf.epp",
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

## Jails available

### Pre-defined jails

#### RedHat

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

#### Debian

* 3proxy
* apache-auth
* apache-badbots
* apache-botsearch
* apache-fakegooglebot
* apache-modsecurity
* apache-multiport
* apache-nohome
* apache-noscript
* apache-overflows
* apache-shellshock
* assp
* asterisk
* bitwarden
* centreon
* counter-strike
* courierauth
* courier-smtp
* cyrus-imap
* directadmin
* domino-smtp
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
* haproxy-http-auth
* horde
* kerio
* lighttpd-auth
* lighttpd-fastcgi
* mongodb-auth
* monit
* murmur
* mysqld-auth
* nagios
* named-refused
* nginx-botsearch
* nginx-http-auth
* nginx-limit-req
* nsd
* openhab-auth
* openwebmail
* oracleims
* pam-generic
* pass2allow-ftp
* perdition
* php-url-fopen
* phpmyadmin-syslog
* portsentry
* postfix
* postfix-rbl
* postfix-sasl
* proftpd
* pure-ftpd
* qmail-rbl
* recidive
* roundcube-auth
* sasl
* selinux-ssh
* sendmail-auth
* sendmail-reject
* sieve
* screensharing
* slapd
* sogo-auth
* solid-pop3d
* squid
* squirrelmail
* ssh
* ssh-blocklist
* ssh-ddos
* ssh-iptables-ipset4
* ssh-iptables-ipset6
* ssh-route
* stunnel
* suhosin
* tine20
* traefik-auth
* uwimap-auth
* vsftpd
* webmin-auth
* wuftpd
* xinetd-fail
* zoneminder
* znc-adminlog

#### Suse

* 3proxy
* apache-auth
* apache-badbots
* apache-botsearch
* apache-common
* apache-fakegooglebot
* apache-modsecurity
* apache-nohome
* apache-noscript
* apache-overflows
* apache-pass
* apache-shellshock
* assp
* asterisk
* botsearch-common
* common
* counter-strike
* courier-auth
* courier-smtp
* cyrus-imap
* directadmin
* domino-smtp
* dovecot
* dropbear
* drupal-auth
* ejabberd-auth
* exim-common
* exim-spam
* exim
* freeswitch
* froxlor-auth
* groupoffice
* gssftpd
* guacamole
* haproxy-http-auth
* horde
* ignorecommands
* kerio
* lighttpd-auth
* mongodb-auth
* monit
* murmur
* mysqld-auth
* nagios
* named-refused
* nginx-botsearch
* nginx-http-auth
* nginx-limit-req
* nsd
* openhab
* openwebmail
* oracleims
* pam-generic
* perdition
* php-url-fopen
* phpmyadmin-syslog
* portsentry
* postfix
* proftpd
* pure-ftpd
* qmail
* recidive
* roundcube-auth
* screensharingd
* selinux-common
* selinux-ssh
* sendmail-auth
* sendmail-reject
* sieve
* slapd
* sogo-auth
* solid-pop3d
* squid
* squirrelmail
* sshd
* stunnel
* suhosin
* tine20
* uwimap-auth
* vsftpd
* webmin-auth
* wuftpd
* xinetd-fail
* zoneminder

### Custom jails

Users can add their own jails by using this YAML definition:

```yaml
---
  fail2ban::custom_jails:
    'nginx-wp-login':
      filter_failregex: '<HOST>.*] "POST /wp-login.php'
      port: 'http,https'
      logpath: '/var/log/nginx/access.log'
      maxretry: 3
      findtime: 120
      bantime: 1200
      ignoreip: ['127.0.0.1', '192.168.1.1/24']
    'nginx-login':
      filter_failregex: '^<HOST> -.*POST /sessions HTTP/1\.." 200'
      action: 'iptables-multiport[name=NoLoginFailures, port="http,https"]'
      logpath: '/var/log/nginx*/*access*.log'
      maxretry: 6
      bantime: 600
      ignoreip: ['127.0.0.1', '192.168.1.1/24']
```

### Sendmail notifications

Default e-mail notification are defined in `/etc/fail2ban/action.d/sendmail-common.conf`. Following configuration will create override config `sendmail-common.local`.

```yaml
fail2ban::sendmail_actions:
  actionstart: ''
  actionstop: ''
fail2ban::sendmail_config:
  dest: root@localhost
  sender: fail2ban@localhost
  sendername: Fail2Ban
```

## Limitations

Supported OSes and dependencies are given into metadata.json file.

## Development

### Bug Report

If you find a bug, have trouble following the documentation or have a question
about this module - please create an issue.

### Pull Request

If you are able to patch the bug or add the feature yourself - please make a
pull request.

### Contributors

The list of contributors can be found at: [https://github.com/voxpupuli/puppet-fail2ban/graphs/contributors](https://github.com/voxpupuli/puppet-fail2ban/graphs/contributors)
