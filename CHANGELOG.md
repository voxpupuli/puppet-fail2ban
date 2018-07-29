# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v2.3.0](https://github.com/voxpupuli/puppet-fail2ban/tree/v2.3.0) (2018-07-29)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v2.2.0...v2.3.0)

**Implemented enhancements:**

- Use the actual default Debian Stretch configuration for jail.conf [\#77](https://github.com/voxpupuli/puppet-fail2ban/pull/77) ([smortex](https://github.com/smortex))

**Fixed bugs:**

- Fix action for strech template [\#72](https://github.com/voxpupuli/puppet-fail2ban/pull/72) ([sileht](https://github.com/sileht))

**Closed issues:**

- Error: Unknown function: 'default\_content' [\#70](https://github.com/voxpupuli/puppet-fail2ban/issues/70)
- Unknown function: 'default\_content [\#69](https://github.com/voxpupuli/puppet-fail2ban/issues/69)

## [v2.2.0](https://github.com/voxpupuli/puppet-fail2ban/tree/v2.2.0) (2018-05-30)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v2.1.0...v2.2.0)

**Implemented enhancements:**

- Allow banaction to be Puppet managed [\#65](https://github.com/voxpupuli/puppet-fail2ban/pull/65) ([saibot94](https://github.com/saibot94))
- Add ignoreip parameter to jail class and template [\#60](https://github.com/voxpupuli/puppet-fail2ban/pull/60) ([leonkoens](https://github.com/leonkoens))

**Closed issues:**

- Banaction in jail.conf cannot be configured by Puppet [\#64](https://github.com/voxpupuli/puppet-fail2ban/issues/64)
- Acceptance tests don't work for CentOS 6 [\#57](https://github.com/voxpupuli/puppet-fail2ban/issues/57)

**Merged pull requests:**

- release 2.2.0 [\#66](https://github.com/voxpupuli/puppet-fail2ban/pull/66) ([traylenator](https://github.com/traylenator))
- Remove docker nodesets [\#63](https://github.com/voxpupuli/puppet-fail2ban/pull/63) ([bastelfreak](https://github.com/bastelfreak))
- drop EOL OSs; fix puppet version range [\#62](https://github.com/voxpupuli/puppet-fail2ban/pull/62) ([bastelfreak](https://github.com/bastelfreak))
- Enable acceptance tests for CentOS 6 [\#54](https://github.com/voxpupuli/puppet-fail2ban/pull/54) ([traylenator](https://github.com/traylenator))

## [v2.1.0](https://github.com/voxpupuli/puppet-fail2ban/tree/v2.1.0) (2018-05-12)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

-  Use os structured fact instead of flat lsb facts [\#43](https://github.com/voxpupuli/puppet-fail2ban/pull/43) ([traylenator](https://github.com/traylenator))
- Add configuration option for iptables\_chain [\#42](https://github.com/voxpupuli/puppet-fail2ban/pull/42) ([brwyatt](https://github.com/brwyatt))
- support a backend parameter for jails [\#37](https://github.com/voxpupuli/puppet-fail2ban/pull/37) ([qs5779](https://github.com/qs5779))

**Closed issues:**

- Can't change sender email in jail.conf [\#51](https://github.com/voxpupuli/puppet-fail2ban/issues/51)
- config\_file\_ensure is not recognized as parameter [\#40](https://github.com/voxpupuli/puppet-fail2ban/issues/40)
- CentOS ssh jail template actually needs "sshd" [\#34](https://github.com/voxpupuli/puppet-fail2ban/issues/34)

**Merged pull requests:**

- Remove config\_file\_ensure [\#56](https://github.com/voxpupuli/puppet-fail2ban/pull/56) ([ekohl](https://github.com/ekohl))
- Use Puppet 4 datatypes [\#55](https://github.com/voxpupuli/puppet-fail2ban/pull/55) ([ekohl](https://github.com/ekohl))
- sender email variabilized [\#52](https://github.com/voxpupuli/puppet-fail2ban/pull/52) ([ryayon](https://github.com/ryayon))
- Make 'ssh' and 'ssh-ddos' jail names be consistent across operating systems [\#50](https://github.com/voxpupuli/puppet-fail2ban/pull/50) ([saibot94](https://github.com/saibot94))

## [v2.0.0](https://github.com/voxpupuli/puppet-fail2ban/tree/v2.0.0) (2018-03-30)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/1.3.4...v2.0.0)

**Breaking changes:**

- modulesync 1.9.0; drop Puppet 3 support, require at least 4.10 [\#45](https://github.com/voxpupuli/puppet-fail2ban/pull/45) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Transfer module to Vox Pupuli [\#46](https://github.com/voxpupuli/puppet-fail2ban/pull/46) ([bastelfreak](https://github.com/bastelfreak))

## [1.3.4](https://github.com/voxpupuli/puppet-fail2ban/tree/1.3.4) (2016-11-30)

### Summary

- [Beaker] Add missing dependency for Beaker tests

## 2016-11-28 Release 1.3.3

### Summary

- [Puppet] Fixed support for CentOS & RedHat releases

## 2016-11-07 Release 1.3.2

### Summary

- [Puppet] Fix jails for Ubuntu 16.04.x (Xenial Xerus)
- [Puppet] Remove default jails at Ubuntu 16.04.x (Xenial Xerus)

## 2016-11-07 Release 1.3.1

### Summary

- [Puppet] Fix typo at action_mb

## 2016-11-07 Release 1.3.0

### Summary

- [Puppet] Add support for RedHat 5 (Tikanga), 6 (Santiago) and 7 (Maipo)
- [Puppet] Add support for Ubuntu 16.04.x (Xenial Xerus)

## 2016-11-06 Release 1.2.2

### Summary

- [Rubocop] Fix several Rubocop issues
- [Puppet] Fix version of module puppet/extlib

## 2016-11-06 Release 1.2.1

### Summary

- [General] Update based on dhoppe/modulesync_config

## 2016-11-05 Release 1.2.0

### Summary

- [General] Update based on dhoppe/modulesync_config
- [Rubocop] Fix several Rubocop issues
- [RSpec] Migrate to rspec-puppet-facts
- [Puppet] Use module puppet/extlib instead of local function default_content
- [Markdown] Fix several Markdown issues
- [Readme] Add missing badges

## 2016-02-07 Release 1.1.1

### Summary

- [Travis CI] Fix matrix of tested Puppet and RVM versions (travis-ci/travis-ci #5580)

## 2016-02-05 Release 1.1.0

### Summary

- [Puppet] Add support for Puppet Enterprise
- [Puppet] Switch to scope syntax of Puppet 3
- [Puppet Forge] Add statistics for downloads, modules and releases
- [Travis CI] Add configuration for coverage reports
- [Rubocop] Resolve several rubocop issues
- [Travis CI] Update matrix of tested Puppet and RVM versions
- [Beaker] Update configuration for beaker
- [RSpec] Update configuration for rspec
- [Rubocop] Add configuration for rubocop
- [RSpec] Add configuration for rspec
- [Rake] Update list of rake tasks
- [Gem] Update list of required gems
- [Git] Update list of ignored files/directories
- [Beaker] Update box/box_url because of new point release

## 2015-08-13 Release 1.0.8

### Summary

- [Beaker] Update Beaker environment
- [RSpec] Update RSpec environment
- [Travis CI] Update Travis CI environment
- [Puppet Forge] Update license, version requirement

## 2015-02-25 Release 1.0.7

### Summary

- [Beaker] Update Beaker environment
- [Travis CI] Update Travis CI environment

## 2015-02-25 Release 1.0.6

### Summary

- [Beaker] Update Beaker environment
- [Puppet] Add support for Debian 8.x (Jessie)

## 2014-12-06 Release 1.0.5

### Summary

- [Puppet] Update documentation
- [Rspec] Made some changes to the build environment

## 2014-12-01 Release 1.0.4

### Summary

- [Puppet] Fix duplicate variable declaration [GH-3](https://github.com/dhoppe/puppet-fail2ban/pull/3)

## 2014-11-09 Release 1.0.3

### Summary

- [Puppet] Switch to top-scope variables
- [Rspec] Enable tests

## 2014-11-09 Release 1.0.2

### Summary

- [Puppet] Amending attributes

## 2014-11-09 Release 1.0.1

### Summary

- [Beaker] Disable test
- [Rspec] Disable tests

## 2014-11-07 Release 1.0.0

### Summary

- Generated from [https://github.com/dhoppe/puppet-skeleton-standard](https://github.com/dhoppe/puppet-skeleton-standard)


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
