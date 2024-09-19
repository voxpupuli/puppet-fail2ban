# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v5.0.2](https://github.com/voxpupuli/puppet-fail2ban/tree/v5.0.2) (2024-09-19)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v5.0.1...v5.0.2)

**Fixed bugs:**

- datatype difference for bantime, datatype erroneous restriction for findtime [\#222](https://github.com/voxpupuli/puppet-fail2ban/pull/222) ([Dan33l](https://github.com/Dan33l))

## [v5.0.1](https://github.com/voxpupuli/puppet-fail2ban/tree/v5.0.1) (2024-09-18)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v5.0.0...v5.0.1)

**Fixed bugs:**

- modulesync 9.3.0 - fix release process [\#220](https://github.com/voxpupuli/puppet-fail2ban/pull/220) ([bastelfreak](https://github.com/bastelfreak))

## [v5.0.0](https://github.com/voxpupuli/puppet-fail2ban/tree/v5.0.0) (2024-09-16)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v4.2.0...v5.0.0)

**Breaking changes:**

- Move description of parameters from README to puppet-strings. [\#219](https://github.com/voxpupuli/puppet-fail2ban/pull/219) ([Dan33l](https://github.com/Dan33l))
- Drop CentOS 8 support [\#217](https://github.com/voxpupuli/puppet-fail2ban/pull/217) ([Dan33l](https://github.com/Dan33l))
- remove support for debian 10 [\#208](https://github.com/voxpupuli/puppet-fail2ban/pull/208) ([TheMeier](https://github.com/TheMeier))
- Drop Puppet 6 support [\#194](https://github.com/voxpupuli/puppet-fail2ban/pull/194) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add support for Ubuntu 24.04 \(noble\) [\#215](https://github.com/voxpupuli/puppet-fail2ban/pull/215) ([amateo](https://github.com/amateo))
- Add tasks to ban/unban IP addresses in jails [\#209](https://github.com/voxpupuli/puppet-fail2ban/pull/209) ([smortex](https://github.com/smortex))
- bump puppet extlib version \< 8.0.0 [\#202](https://github.com/voxpupuli/puppet-fail2ban/pull/202) ([sandwitch](https://github.com/sandwitch))
- Add Puppet 8 support [\#198](https://github.com/voxpupuli/puppet-fail2ban/pull/198) ([bastelfreak](https://github.com/bastelfreak))
- Add support for Debian 12 [\#197](https://github.com/voxpupuli/puppet-fail2ban/pull/197) ([cFire](https://github.com/cFire))
- Allow puppetlabs-stdlib 9.x [\#196](https://github.com/voxpupuli/puppet-fail2ban/pull/196) ([smortex](https://github.com/smortex))

**Fixed bugs:**

- Use actual Debian 11 configuration [\#191](https://github.com/voxpupuli/puppet-fail2ban/pull/191) ([smortex](https://github.com/smortex))
- `logpath` is not required when `journalmatch` in provided [\#190](https://github.com/voxpupuli/puppet-fail2ban/pull/190) ([smortex](https://github.com/smortex))

## [v4.2.0](https://github.com/voxpupuli/puppet-fail2ban/tree/v4.2.0) (2022-11-10)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v4.1.0...v4.2.0)

**Implemented enhancements:**

- Add support for Ubuntu 22.04 [\#178](https://github.com/voxpupuli/puppet-fail2ban/pull/178) ([grant-veepshosting](https://github.com/grant-veepshosting))

**Closed issues:**

- Template for Rocky Linux 8 [\#183](https://github.com/voxpupuli/puppet-fail2ban/issues/183)

## [v4.1.0](https://github.com/voxpupuli/puppet-fail2ban/tree/v4.1.0) (2022-04-12)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v4.0.0...v4.1.0)

**Implemented enhancements:**

- Consolidate jail.conf.epp for RedHat osfamily [\#177](https://github.com/voxpupuli/puppet-fail2ban/pull/177) ([traylenator](https://github.com/traylenator))
- Support CentOS/RHEL/Alma/Rocky 9 [\#176](https://github.com/voxpupuli/puppet-fail2ban/pull/176) ([traylenator](https://github.com/traylenator))
- Allow puppet/extlib 6.x [\#174](https://github.com/voxpupuli/puppet-fail2ban/pull/174) ([bastelfreak](https://github.com/bastelfreak))
- Add AlmaLinux & Rocky config, identical to CentOS [\#163](https://github.com/voxpupuli/puppet-fail2ban/pull/163) ([vollmerk](https://github.com/vollmerk))
- Initial support for openSUSE [\#158](https://github.com/voxpupuli/puppet-fail2ban/pull/158) ([mattqm](https://github.com/mattqm))

**Fixed bugs:**

- Fix apache-badbots on RedHat [\#148](https://github.com/voxpupuli/puppet-fail2ban/pull/148) ([deric](https://github.com/deric))

## [v4.0.0](https://github.com/voxpupuli/puppet-fail2ban/tree/v4.0.0) (2021-12-13)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v3.3.0...v4.0.0)

**Breaking changes:**

- Drop support for Debian 8, 9; Ubuntu 16.04; RedHat 6; CentOS 6 \(EOL\) [\#167](https://github.com/voxpupuli/puppet-fail2ban/pull/167) ([smortex](https://github.com/smortex))
- Drop support of Puppet 5 \(EOL\) [\#166](https://github.com/voxpupuli/puppet-fail2ban/pull/166) ([smortex](https://github.com/smortex))

**Implemented enhancements:**

- Add support for Debian 11 bullseye [\#170](https://github.com/voxpupuli/puppet-fail2ban/pull/170) ([michaelw](https://github.com/michaelw))
- Add support for Puppet 7 [\#168](https://github.com/voxpupuli/puppet-fail2ban/pull/168) ([smortex](https://github.com/smortex))

**Closed issues:**

- "no directory /var/run/fail2ban to contain the socket file" [\#35](https://github.com/voxpupuli/puppet-fail2ban/issues/35)

**Merged pull requests:**

- Allow stdlib 8.0.0 [\#165](https://github.com/voxpupuli/puppet-fail2ban/pull/165) ([smortex](https://github.com/smortex))

## [v3.3.0](https://github.com/voxpupuli/puppet-fail2ban/tree/v3.3.0) (2020-08-15)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v3.2.0...v3.3.0)

**Merged pull requests:**

- Add Ubuntu 20.04 support [\#151](https://github.com/voxpupuli/puppet-fail2ban/pull/151) ([davealden](https://github.com/davealden))

## [v3.2.0](https://github.com/voxpupuli/puppet-fail2ban/tree/v3.2.0) (2020-05-05)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v3.1.0...v3.2.0)

**Implemented enhancements:**

- Add parameters manage\_defaults, manage\_firewalld [\#147](https://github.com/voxpupuli/puppet-fail2ban/pull/147) ([dhoppe](https://github.com/dhoppe))
- Support overriding service notifications \(\#143\) [\#144](https://github.com/voxpupuli/puppet-fail2ban/pull/144) ([deric](https://github.com/deric))

**Closed issues:**

- Why is firewalld being "deactivated" [\#146](https://github.com/voxpupuli/puppet-fail2ban/issues/146)
- Option to disable service start/stop notifications [\#143](https://github.com/voxpupuli/puppet-fail2ban/issues/143)

**Merged pull requests:**

- Fix several markdown lint issues [\#142](https://github.com/voxpupuli/puppet-fail2ban/pull/142) ([dhoppe](https://github.com/dhoppe))

## [v3.1.0](https://github.com/voxpupuli/puppet-fail2ban/tree/v3.1.0) (2020-04-22)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v3.0.0...v3.1.0)

**Implemented enhancements:**

- Add support for multiple data types [\#140](https://github.com/voxpupuli/puppet-fail2ban/pull/140) ([dhoppe](https://github.com/dhoppe))
- Add default\_backend param defaulting to "auto" [\#130](https://github.com/voxpupuli/puppet-fail2ban/pull/130) ([brunoleon](https://github.com/brunoleon))

**Closed issues:**

- Allow multiple data types [\#139](https://github.com/voxpupuli/puppet-fail2ban/issues/139)
- Update puppet forge [\#116](https://github.com/voxpupuli/puppet-fail2ban/issues/116)

## [v3.0.0](https://github.com/voxpupuli/puppet-fail2ban/tree/v3.0.0) (2020-04-21)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v2.4.1...v3.0.0)

**Breaking changes:**

- Remove any lsb facts usage [\#135](https://github.com/voxpupuli/puppet-fail2ban/pull/135) ([neomilium](https://github.com/neomilium))
- drop Ubuntu 14.04 support [\#121](https://github.com/voxpupuli/puppet-fail2ban/pull/121) ([bastelfreak](https://github.com/bastelfreak))
- modulesync 2.7.0 and drop puppet 4 [\#110](https://github.com/voxpupuli/puppet-fail2ban/pull/110) ([bastelfreak](https://github.com/bastelfreak))
- Use custom\_jails parameter [\#100](https://github.com/voxpupuli/puppet-fail2ban/pull/100) ([kobybr](https://github.com/kobybr))

**Implemented enhancements:**

- Add support for CentOS / RedHat 8 [\#137](https://github.com/voxpupuli/puppet-fail2ban/pull/137) ([dhoppe](https://github.com/dhoppe))
- allow extlib 5.x [\#128](https://github.com/voxpupuli/puppet-fail2ban/pull/128) ([bastelfreak](https://github.com/bastelfreak))
- Add Debian10 support [\#114](https://github.com/voxpupuli/puppet-fail2ban/pull/114) ([bastelfreak](https://github.com/bastelfreak))
- Allow puppet/extlib 4.x and puppetlabs/stdlib 6.x [\#111](https://github.com/voxpupuli/puppet-fail2ban/pull/111) ([alexjfisher](https://github.com/alexjfisher))
- Add filter options [\#107](https://github.com/voxpupuli/puppet-fail2ban/pull/107) ([coreone](https://github.com/coreone))
- Add support for journalmatch [\#95](https://github.com/voxpupuli/puppet-fail2ban/pull/95) ([cwells](https://github.com/cwells))
- Add jail.conf.epp template for bionic [\#89](https://github.com/voxpupuli/puppet-fail2ban/pull/89) ([mnencia](https://github.com/mnencia))

**Fixed bugs:**

- Template header causes service restart [\#29](https://github.com/voxpupuli/puppet-fail2ban/issues/29)
- Fix non namespaced extlib function [\#131](https://github.com/voxpupuli/puppet-fail2ban/pull/131) ([neomilium](https://github.com/neomilium))
- Fixes a template bug with 'ignoreip' so that it 'Inserts the value of… [\#109](https://github.com/voxpupuli/puppet-fail2ban/pull/109) ([dwest-galois](https://github.com/dwest-galois))
- Replace UTF8 dash and quotes in templates [\#106](https://github.com/voxpupuli/puppet-fail2ban/pull/106) ([linuxdaemon](https://github.com/linuxdaemon))

**Closed issues:**

- Move templates [\#132](https://github.com/voxpupuli/puppet-fail2ban/issues/132)
- Support for RHEL/CentOS 8 [\#126](https://github.com/voxpupuli/puppet-fail2ban/issues/126)
- ignoreip in custom jails  not populating [\#120](https://github.com/voxpupuli/puppet-fail2ban/issues/120)
- Missing directories when using custom jails [\#117](https://github.com/voxpupuli/puppet-fail2ban/issues/117)
- custom\_jails are not populating the 'ignoreip" values in the custom\_jail.conf.epp template [\#108](https://github.com/voxpupuli/puppet-fail2ban/issues/108)
- Use of U+2013 \(EN DASH\) in trusty template causes puppetdb errors [\#105](https://github.com/voxpupuli/puppet-fail2ban/issues/105)
- Could not find template 'fail2ban//etc/fail2ban/jail.conf.erb' - CentOS Linux release 7.6.1810 \(Core\) [\#102](https://github.com/voxpupuli/puppet-fail2ban/issues/102)
- Allow use of custom\_jails param passed to in main class [\#99](https://github.com/voxpupuli/puppet-fail2ban/issues/99)
- Could not find template 'fail2ban/stretch/etc/fail2ban/jail.conf.erb' [\#88](https://github.com/voxpupuli/puppet-fail2ban/issues/88)
- Deprecation warnings [\#28](https://github.com/voxpupuli/puppet-fail2ban/issues/28)

**Merged pull requests:**

- Use voxpupuli-acceptance [\#136](https://github.com/voxpupuli/puppet-fail2ban/pull/136) ([ekohl](https://github.com/ekohl))
- update repo links to https [\#129](https://github.com/voxpupuli/puppet-fail2ban/pull/129) ([bastelfreak](https://github.com/bastelfreak))
- Remove unsupported releases [\#123](https://github.com/voxpupuli/puppet-fail2ban/pull/123) ([dhoppe](https://github.com/dhoppe))
- Clean up acceptance spec helper [\#119](https://github.com/voxpupuli/puppet-fail2ban/pull/119) ([ekohl](https://github.com/ekohl))
- depend on extlib 3 & prefix extlib function call [\#115](https://github.com/voxpupuli/puppet-fail2ban/pull/115) ([bastelfreak](https://github.com/bastelfreak))

## [v2.4.1](https://github.com/voxpupuli/puppet-fail2ban/tree/v2.4.1) (2018-10-17)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v2.4.0...v2.4.1)

**Fixed bugs:**

- Bugfix for broken epp templates [\#86](https://github.com/voxpupuli/puppet-fail2ban/pull/86) ([cFire](https://github.com/cFire))

**Closed issues:**

- SyntaxError on debian stretch epp template [\#84](https://github.com/voxpupuli/puppet-fail2ban/issues/84)
- help for load custom jails on debian [\#74](https://github.com/voxpupuli/puppet-fail2ban/issues/74)
- Custom jail doesn't work on Debian Wheezy [\#27](https://github.com/voxpupuli/puppet-fail2ban/issues/27)

**Merged pull requests:**

- modulesync 2.1.0 and allow puppet 6.x [\#91](https://github.com/voxpupuli/puppet-fail2ban/pull/91) ([bastelfreak](https://github.com/bastelfreak))
- allow puppet/extlib 3.x [\#90](https://github.com/voxpupuli/puppet-fail2ban/pull/90) ([bastelfreak](https://github.com/bastelfreak))
- allow puppetlabs/stdlib 5.x [\#85](https://github.com/voxpupuli/puppet-fail2ban/pull/85) ([bastelfreak](https://github.com/bastelfreak))

## [v2.4.0](https://github.com/voxpupuli/puppet-fail2ban/tree/v2.4.0) (2018-08-18)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v2.3.0...v2.4.0)

**Implemented enhancements:**

- Make `before` setting in jail.conf configurable [\#68](https://github.com/voxpupuli/puppet-fail2ban/pull/68) ([arjenz](https://github.com/arjenz))

**Closed issues:**

- Debian Stretch [\#36](https://github.com/voxpupuli/puppet-fail2ban/issues/36)

## [v2.3.0](https://github.com/voxpupuli/puppet-fail2ban/tree/v2.3.0) (2018-08-02)

[Full Changelog](https://github.com/voxpupuli/puppet-fail2ban/compare/v2.2.0...v2.3.0)

**Implemented enhancements:**

- Use the actual default Debian Stretch configuration for jail.conf [\#77](https://github.com/voxpupuli/puppet-fail2ban/pull/77) ([smortex](https://github.com/smortex))

**Fixed bugs:**

- Fix typo in parameter default [\#80](https://github.com/voxpupuli/puppet-fail2ban/pull/80) ([ekohl](https://github.com/ekohl))
- Fix action for strech template [\#72](https://github.com/voxpupuli/puppet-fail2ban/pull/72) ([sileht](https://github.com/sileht))

**Closed issues:**

- Error: Unknown function: 'default\_content' [\#70](https://github.com/voxpupuli/puppet-fail2ban/issues/70)
- Unknown function: 'default\_content [\#69](https://github.com/voxpupuli/puppet-fail2ban/issues/69)
- Typo in variable name [\#24](https://github.com/voxpupuli/puppet-fail2ban/issues/24)

**Merged pull requests:**

- Switch to epp templates [\#79](https://github.com/voxpupuli/puppet-fail2ban/pull/79) ([smortex](https://github.com/smortex))
- Add unit test for checking sender address [\#75](https://github.com/voxpupuli/puppet-fail2ban/pull/75) ([smortex](https://github.com/smortex))

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
