# fail2ban

[![License](https://img.shields.io/github/license/voxpupuli/puppet-fail2ban.svg)](https://github.com/voxpupuli/puppet-fail2ban/blob/master/LICENSE)
[![Build Status](https://github.com/voxpupuli/puppet-fail2ban/actions/workflows/ci.yml/badge.svg)](https://github.com/voxpupuli/puppet-fail2ban/actions/workflows/ci.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/fail2ban.svg)](https://forge.puppetlabs.com/puppet/fail2ban)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/fail2ban.svg)](https://forge.puppetlabs.com/puppet/fail2ban)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/fail2ban.svg)](https://forge.puppetlabs.com/puppet/fail2ban)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/fail2ban.svg)](https://forge.puppetlabs.com/puppet/fail2ban)

## Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
   1. [What puppet-fail2ban affects](#what-puppet-fail2ban-affects)
   2. [Beginning with fail2ban](#beginning-with-fail2ban)
   3. [Migrating from puppet-fail2ban \<= 6.x](#migrating-from-puppet-fail2ban--6x)
4. [Usage](#usage)
   1. [Package and Service](#package-and-service)
   2. [jail.local](#jaillocal)
   3. [Custom actions](#custom-actions)
   4. [Custom filters](#custom-filters)
   5. [Custom jails](#custom-jails)
5. [Limitations](#limitations)
6. [Development](#development)
   1. [Bug Report](#bug-report)
   2. [Pull Request](#pull-request)
   3. [Contributors](#contributors)

## Overview

This module installs, configures and manages the Fail2ban service.

## Module Description

This module handles installing, configuring and running [Fail2ban](https://github.com/fail2ban/fail2ban)
across a range of operating systems and distributions.

## Setup

### What puppet-fail2ban affects

* fail2ban package.
* fail2ban configuration files.
* fail2ban service.


### Beginning with fail2ban

Install `fail2ban` with distro defaults and start/enable service:

```puppet
    class { 'fail2ban': }
```

### Migrating from puppet-fail2ban <= 6.x

Fail2ban was heavily refactored in 0.9.0 release and puppet-fail2ban 7.x
reflects this. Configuration is now done overriding `.conf` files with `.local`
files, changing only the intended parameters and keeping everything else to the
default.

```shell
# Backup fail2ban configuration
cp --recursive /etc/fail2ban /etc/fail2ban.old
# Purge fail2ban package and configuration, according to your distribution and
# then reinstall it with a clean configuration
## Debian, Ubuntu
sudo apt-get purge fail2ban && sudo apt-get install fail2ban
## Enterprise Linux (Almalinux, CentOS Stream, RHEL, Rocky Linux)
sudo dnf remove fail2ban && sudo dnf install fail2ban
## openSUSE
sudo zypper rm fail2ban && sudo zypper install fail2ban
```
Now compare the "stock" configuration of fail2ban in `/etc/fail2ban` with the
one you have in `/etc/fail2ban.old` and use the module to only apply differences
between the stock configuration and your old one.

## Usage

### Package and Service

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

Disable the fail2ban service.

```puppet
    class { 'fail2ban':
      service_ensure => 'stopped',
    }
```

### jail.local

Parameters in `jail.conf` now are not edited directly but overridden in
`jail.local`, so for example:

```puppet
    class { 'fail2ban':
      bantime  => '30m',
      maxretry => 5,
      jails => {
        sshd => {
          enabled => true,
          bantime => '1h',
        },
        ssh-selinux => {
          enabled => true,
        },
      },
    }
```

Will result in:

```
[DEFAULT]
bantime = 30m
maxretry = 5

[sshd]
enabled = true
bantime = 1h

[ssh-selinux]
enabled = true
```

Allowing to override default bantime and retry number, and enabling two default
jails (already defined in `jail.conf`).

### Custom actions

Custom actions or changes to default actions are managed as resources.

```puppet
fail2ban::action { 'Set AbuseIPDB API key':
  action_name => 'abuseipdb',
  action_content => {
    'Init' => {
      'abuseipdb_apikey' => 'my-very-secret-api-key',
    },
  },
}
```

Will create `/etc/fail2ban/action.d/abuseipdb.local`, that complements
`abuseipdb.conf`:

```
[Init]
abuseipdb_apikey = my-very-secret-api-key
```

**Note that there is no content validation** - everything in the content hash is
inserted in the generated file.

### Custom filters

Custom filters or changes to default filters are managed as resources.

```puppet
fail2ban::filter { 'Change log type':
  filter_name    => 'common',
  filter_content => {
    'DEFAULT' => {
      'logtype' => 'short',
    },
  },
}
```

Will result in `/etc/fail2ban/filter.d/common.local`

```
[DEFAULT]
logtype = short
```

**Note that there is no content validation** - everything in the content hash is
inserted in the generated file.

### Custom jails

Custom jails (or changes to default jails, even if for these is recommended
`jail.local`) are managed as resources.

```puppet
fail2ban::jail { 'Filter attempt to wp-login':
  jail_name    => 'nginx-wp-login',
  jail_content => {
    'nginx-wp-login' => {
      jail_failregex => '<HOST>.*] "POST /wp-login.php',
      port           => 'http,https',
      logpath        => '/var/log/nginx/access.log',
      maxretry       => 3,
      findtime       => 120,
      bantime        => 1200,
      ignoreip       => ['127.0.0.1', '192.168.1.1/24'],
    },
  },
}
```

Will create `/etc/fail2ban/jail.d/nginx-wp-login.local`:

```
[nginx-wp-login]
jail_failregex = <HOST>.*] "POST /wp-login.php
port = http,https
logpath = /var/log/nginx/access.log
maxretry = 3
findtime = 120
bantime = 1200
ignoreip = 127.0.0.1, 192.168.1.1/24
```

```puppet
fail2ban::jail { 'Filter login attempts':
  jail_name    => 'nginx-login',
  jail_content => {
    'nginx-wp-login' => {
      filter_failregex => '^<HOST> -.*POST /sessions HTTP/1\.." 200',
      action           => 'iptables-multiport[name=NoLoginFailures, port="http,https"]',
      logpath          => '/var/log/nginx*/*access*.log',
      maxretry         => 6,
      bantime          => 600,
      ignoreip         => ['127.0.0.1', '192.168.1.1/24'],
    },
  },
}
```

Will create `/etc/fail2ban/jail.d/nginx-login.local`:

```
[nginx-login]
filter_failregex = <HOST>.*] ^<HOST> -.*POST /sessions HTTP/1\.." 200
action = iptables-multiport[name=NoLoginFailures, port="http,https"]
logpath = /var/log/nginx*/*access*.log
maxretry = 6
findtime = 600
ignoreip = 127.0.0.1, 192.168.1.1/24
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
