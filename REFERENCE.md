# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

* [`fail2ban`](#fail2ban): == Class: fail2ban
* [`fail2ban::config`](#fail2banconfig): == Class: fail2ban::config
* [`fail2ban::install`](#fail2baninstall): == Class: fail2ban::install
* [`fail2ban::service`](#fail2banservice): == Class: fail2ban::service

### Defined types

* [`fail2ban::define`](#fail2bandefine): == Define: fail2ban::define
* [`fail2ban::jail`](#fail2banjail): == Define: fail2ban::jail

## Classes

### <a name="fail2ban"></a>`fail2ban`

== Class: fail2ban

#### Parameters

The following parameters are available in the `fail2ban` class:

* [`config_file_before`](#config_file_before)
* [`package_ensure`](#package_ensure)
* [`package_name`](#package_name)
* [`package_list`](#package_list)
* [`config_dir_path`](#config_dir_path)
* [`config_dir_filter_path`](#config_dir_filter_path)
* [`config_dir_purge`](#config_dir_purge)
* [`config_dir_recurse`](#config_dir_recurse)
* [`config_dir_source`](#config_dir_source)
* [`config_file_path`](#config_file_path)
* [`config_file_owner`](#config_file_owner)
* [`config_file_group`](#config_file_group)
* [`config_file_mode`](#config_file_mode)
* [`config_file_source`](#config_file_source)
* [`config_file_string`](#config_file_string)
* [`config_file_template`](#config_file_template)
* [`config_file_notify`](#config_file_notify)
* [`config_file_require`](#config_file_require)
* [`config_file_hash`](#config_file_hash)
* [`config_file_options_hash`](#config_file_options_hash)
* [`manage_defaults`](#manage_defaults)
* [`manage_firewalld`](#manage_firewalld)
* [`service_ensure`](#service_ensure)
* [`service_name`](#service_name)
* [`service_enable`](#service_enable)
* [`action`](#action)
* [`bantime`](#bantime)
* [`email`](#email)
* [`sender`](#sender)
* [`iptables_chain`](#iptables_chain)
* [`jails`](#jails)
* [`maxretry`](#maxretry)
* [`default_backend`](#default_backend)
* [`whitelist`](#whitelist)
* [`custom_jails`](#custom_jails)
* [`banaction`](#banaction)
* [`sendmail_config`](#sendmail_config)
* [`sendmail_actions`](#sendmail_actions)

##### <a name="config_file_before"></a>`config_file_before`

Data type: `String[1]`



##### <a name="package_ensure"></a>`package_ensure`

Data type: `Enum['absent', 'latest', 'present', 'purged']`



Default value: `'present'`

##### <a name="package_name"></a>`package_name`

Data type: `String[1]`



Default value: `'fail2ban'`

##### <a name="package_list"></a>`package_list`

Data type: `Optional[Array[String]]`



Default value: ``undef``

##### <a name="config_dir_path"></a>`config_dir_path`

Data type: `Stdlib::Absolutepath`



Default value: `'/etc/fail2ban'`

##### <a name="config_dir_filter_path"></a>`config_dir_filter_path`

Data type: `Stdlib::Absolutepath`



Default value: `'/etc/fail2ban/filter.d'`

##### <a name="config_dir_purge"></a>`config_dir_purge`

Data type: `Boolean`



Default value: ``false``

##### <a name="config_dir_recurse"></a>`config_dir_recurse`

Data type: `Boolean`



Default value: ``true``

##### <a name="config_dir_source"></a>`config_dir_source`

Data type: `Optional[String]`



Default value: ``undef``

##### <a name="config_file_path"></a>`config_file_path`

Data type: `Stdlib::Absolutepath`



Default value: `'/etc/fail2ban/jail.conf'`

##### <a name="config_file_owner"></a>`config_file_owner`

Data type: `String[1]`



Default value: `'root'`

##### <a name="config_file_group"></a>`config_file_group`

Data type: `String[1]`



Default value: `'root'`

##### <a name="config_file_mode"></a>`config_file_mode`

Data type: `String[1]`



Default value: `'0644'`

##### <a name="config_file_source"></a>`config_file_source`

Data type: `Optional[String[1]]`



Default value: ``undef``

##### <a name="config_file_string"></a>`config_file_string`

Data type: `Optional[String[1]]`



Default value: ``undef``

##### <a name="config_file_template"></a>`config_file_template`

Data type: `Optional[String[1]]`



Default value: ``undef``

##### <a name="config_file_notify"></a>`config_file_notify`

Data type: `String[1]`



Default value: `'Service[fail2ban]'`

##### <a name="config_file_require"></a>`config_file_require`

Data type: `String[1]`



Default value: `'Package[fail2ban]'`

##### <a name="config_file_hash"></a>`config_file_hash`

Data type: `Hash[String[1], Any]`



Default value: `{}`

##### <a name="config_file_options_hash"></a>`config_file_options_hash`

Data type: `Hash`



Default value: `{}`

##### <a name="manage_defaults"></a>`manage_defaults`

Data type: `Enum['absent', 'present']`



Default value: `'absent'`

##### <a name="manage_firewalld"></a>`manage_firewalld`

Data type: `Enum['absent', 'present']`



Default value: `'absent'`

##### <a name="service_ensure"></a>`service_ensure`

Data type: `Enum['running', 'stopped']`



Default value: `'running'`

##### <a name="service_name"></a>`service_name`

Data type: `String[1]`



Default value: `'fail2ban'`

##### <a name="service_enable"></a>`service_enable`

Data type: `Boolean`



Default value: ``true``

##### <a name="action"></a>`action`

Data type: `String[1]`



Default value: `'action_mb'`

##### <a name="bantime"></a>`bantime`

Data type: `Variant[Integer[0], String[1]]`



Default value: `432000`

##### <a name="email"></a>`email`

Data type: `String[1]`



Default value: `"fail2ban@${facts['networking']['domain']}"`

##### <a name="sender"></a>`sender`

Data type: `String[1]`



Default value: `"fail2ban@${facts['networking']['fqdn']}"`

##### <a name="iptables_chain"></a>`iptables_chain`

Data type: `String[1]`



Default value: `'INPUT'`

##### <a name="jails"></a>`jails`

Data type: `Array[String[1]]`



Default value: `['ssh', 'ssh-ddos']`

##### <a name="maxretry"></a>`maxretry`

Data type: `Integer[0]`



Default value: `3`

##### <a name="default_backend"></a>`default_backend`

Data type: `Enum['pyinotify', 'gamin', 'polling', 'systemd', 'auto']`



Default value: `'auto'`

##### <a name="whitelist"></a>`whitelist`

Data type: `Array`



Default value: `['127.0.0.1/8', '192.168.56.0/24']`

##### <a name="custom_jails"></a>`custom_jails`

Data type: `Hash[String, Hash]`



Default value: `{}`

##### <a name="banaction"></a>`banaction`

Data type: `String[1]`



Default value: `'iptables-multiport'`

##### <a name="sendmail_config"></a>`sendmail_config`

Data type: `Hash`



Default value: `{}`

##### <a name="sendmail_actions"></a>`sendmail_actions`

Data type: `Hash`



Default value: `{}`

### <a name="fail2banconfig"></a>`fail2ban::config`

== Class: fail2ban::config

### <a name="fail2baninstall"></a>`fail2ban::install`

== Class: fail2ban::install

### <a name="fail2banservice"></a>`fail2ban::service`

== Class: fail2ban::service

## Defined types

### <a name="fail2bandefine"></a>`fail2ban::define`

== Define: fail2ban::define

#### Parameters

The following parameters are available in the `fail2ban::define` defined type:

* [`config_file_path`](#config_file_path)
* [`config_file_owner`](#config_file_owner)
* [`config_file_group`](#config_file_group)
* [`config_file_mode`](#config_file_mode)
* [`config_file_source`](#config_file_source)
* [`config_file_string`](#config_file_string)
* [`config_file_template`](#config_file_template)
* [`config_file_notify`](#config_file_notify)
* [`config_file_require`](#config_file_require)
* [`config_file_options_hash`](#config_file_options_hash)

##### <a name="config_file_path"></a>`config_file_path`

Data type: `Stdlib::Absolutepath`



Default value: `"${fail2ban::config_dir_path}/${title}"`

##### <a name="config_file_owner"></a>`config_file_owner`

Data type: `String`



Default value: `$fail2ban::config_file_owner`

##### <a name="config_file_group"></a>`config_file_group`

Data type: `String`



Default value: `$fail2ban::config_file_group`

##### <a name="config_file_mode"></a>`config_file_mode`

Data type: `String`



Default value: `$fail2ban::config_file_mode`

##### <a name="config_file_source"></a>`config_file_source`

Data type: `Optional[String]`



Default value: ``undef``

##### <a name="config_file_string"></a>`config_file_string`

Data type: `Optional[String]`



Default value: ``undef``

##### <a name="config_file_template"></a>`config_file_template`

Data type: `Optional[String]`



Default value: ``undef``

##### <a name="config_file_notify"></a>`config_file_notify`

Data type: `String`



Default value: `$fail2ban::config_file_notify`

##### <a name="config_file_require"></a>`config_file_require`

Data type: `String`



Default value: `$fail2ban::config_file_require`

##### <a name="config_file_options_hash"></a>`config_file_options_hash`

Data type: `Hash`



Default value: `$fail2ban::config_file_options_hash`

### <a name="fail2banjail"></a>`fail2ban::jail`

== Define: fail2ban::jail

#### Parameters

The following parameters are available in the `fail2ban::jail` defined type:

* [`filter_includes`](#filter_includes)
* [`filter_failregex`](#filter_failregex)
* [`filter_ignoreregex`](#filter_ignoreregex)
* [`filter_maxlines`](#filter_maxlines)
* [`filter_datepattern`](#filter_datepattern)
* [`filter_additional_config`](#filter_additional_config)
* [`enabled`](#enabled)
* [`action`](#action)
* [`filter`](#filter)
* [`logpath`](#logpath)
* [`maxretry`](#maxretry)
* [`findtime`](#findtime)
* [`bantime`](#bantime)
* [`port`](#port)
* [`backend`](#backend)
* [`journalmatch`](#journalmatch)
* [`ignoreip`](#ignoreip)
* [`config_dir_filter_path`](#config_dir_filter_path)
* [`config_file_owner`](#config_file_owner)
* [`config_file_group`](#config_file_group)
* [`config_file_mode`](#config_file_mode)
* [`config_file_source`](#config_file_source)
* [`config_file_notify`](#config_file_notify)
* [`config_file_require`](#config_file_require)

##### <a name="filter_includes"></a>`filter_includes`

Data type: `Optional[String]`



Default value: ``undef``

##### <a name="filter_failregex"></a>`filter_failregex`

Data type: `Optional[String]`



Default value: ``undef``

##### <a name="filter_ignoreregex"></a>`filter_ignoreregex`

Data type: `Optional[String]`



Default value: ``undef``

##### <a name="filter_maxlines"></a>`filter_maxlines`

Data type: `Optional[Integer]`



Default value: ``undef``

##### <a name="filter_datepattern"></a>`filter_datepattern`

Data type: `Optional[String]`



Default value: ``undef``

##### <a name="filter_additional_config"></a>`filter_additional_config`

Data type: `Any`



Default value: ``undef``

##### <a name="enabled"></a>`enabled`

Data type: `Boolean`



Default value: ``true``

##### <a name="action"></a>`action`

Data type: `Optional[String]`



Default value: ``undef``

##### <a name="filter"></a>`filter`

Data type: `String`



Default value: `$title`

##### <a name="logpath"></a>`logpath`

Data type: `String`



Default value: ``undef``

##### <a name="maxretry"></a>`maxretry`

Data type: `Integer`



Default value: `$fail2ban::maxretry`

##### <a name="findtime"></a>`findtime`

Data type: `Optional[Integer]`



Default value: ``undef``

##### <a name="bantime"></a>`bantime`

Data type: `Integer`



Default value: `$fail2ban::bantime`

##### <a name="port"></a>`port`

Data type: `Optional[String]`



Default value: ``undef``

##### <a name="backend"></a>`backend`

Data type: `Optional[String]`



Default value: ``undef``

##### <a name="journalmatch"></a>`journalmatch`

Data type: `Optional[String[1]]`



Default value: ``undef``

##### <a name="ignoreip"></a>`ignoreip`

Data type: `Array[Stdlib::IP::Address]`



Default value: `[]`

##### <a name="config_dir_filter_path"></a>`config_dir_filter_path`

Data type: `Stdlib::Absolutepath`



Default value: `$fail2ban::config_dir_filter_path`

##### <a name="config_file_owner"></a>`config_file_owner`

Data type: `Optional[String]`



Default value: `$fail2ban::config_file_owner`

##### <a name="config_file_group"></a>`config_file_group`

Data type: `Optional[String]`



Default value: `$fail2ban::config_file_group`

##### <a name="config_file_mode"></a>`config_file_mode`

Data type: `Optional[String]`



Default value: `$fail2ban::config_file_mode`

##### <a name="config_file_source"></a>`config_file_source`

Data type: `Optional[String]`



Default value: `$fail2ban::config_file_source`

##### <a name="config_file_notify"></a>`config_file_notify`

Data type: `Optional[String]`



Default value: `$fail2ban::config_file_notify`

##### <a name="config_file_require"></a>`config_file_require`

Data type: `Optional[String]`



Default value: `$fail2ban::config_file_require`
