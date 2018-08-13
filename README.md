# AMCS SecC - OpenSSH Module

[![Build Status](https://travis-ci.org/T-Systems-MMS/puppet-secc_sshd.svg?branch=master)](https://travis-ci.org/T-Systems-MMS/puppet-secc_sshd)

## Table of Contents

1. [Overview](#overview)
2. [Some important remarks](#important)
3. [Module Description - What the module does and why it is useful](#module-description)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Overview

This module is used widely (on every machine) within T-Systems MMS to ensure compliance to our regulations (Telekom Security), Privacy and Security Assessment - 3_04_Secure_Shell_(SSH). Both, client (ssh) and server (sshd), are covered.

## Important

Hardening is always a tradeoff between security and useability. Therefore the parameters of that puppet module allow flexible changes on some settings, but is also providing secure defaults. If there is a missing parameter, please open an issue.
If a default parameter is changed, the compliance has to be verified by the user or the project.

## Module Description

This module controls /etc/ssh/sshd_config, /etc/ssh/ssh_config, /etc/issue and /etc/motd

### sshd_config

- SoC Requirements 1 - 8, (9), 10-12 are fulfilled without restrictions.
- SoC Requirement 9 has a parameter, because that module is used on our administration jump hosts, where we need the agent forwarding.
  - default parameter is compliant
- SoC Requirements 13, (14), 17, 18 are fulfilled via public key authentication and their settings.
  - challengeresponseauthentication has a parameter, because that's sometimes necessary for bootstrapping. Some images are allowing that initially, and are hardened after provisioning.
- SoC Requirement 15 is not compliant by default, because other modules are being used for user management, which are either not supporting the change of the key folders or do not secure that folder according to the requirement.
  - This module atleast can be adjusted to a matching module, by adjusting the parameter AuthorizedKeysFile.
- SoC Requirement 16 has to be taken care by every project individually.
- SoC Requirement 21 (the daemon part) is compliant without restrictions.

### ssh_config

- SoC Requirements 19, 22 are fulfilled without restrictions.
- SoC Requirement 20 (security of the private key) cannot be verified by ssh client or daemon.
- SoC Requirement 21 (usage of the ssh auth-agent) cannot be verified by ssh client or daemon.

## Usage

- Either include the module via git or puppetforge. (T-Systems is using r10k)

### Usage without Puppet

- The templates, ssh_config.erb and sshd_config.erb, can be used without puppet. There is no deep ruby or puppet knowhow needed.
- The disclaimer, that those files are managed by puppet, should be removed.

### Verification

- The tests (spec/acceptance) can be used to verify the hardening, even without using the module on your servers.

## Reference

- The hardening requirements are from Telekom Security, Privacy and Security Assessment - 3_04_Secure_Shell_(SSH). Last verified on 2018-07-31.

## Limitations

- Module is being developed and verified on CentOS6, CentOS7 and RHEL6, RHEL7.

## Development

- Any changes to the module should also be implemented into the test scripts (see spec/acceptance).
