# AMCS SecC - OpenSSH Module

[![Build Status](https://travis-ci.org/T-Systems-MMS/puppet-secc_sshd.svg?branch=master)](https://travis-ci.org/T-Systems-MMS/puppet-secc_sshd)

## Table of Contents

1. [Overview](#overview)
2. [Fragen und Anmerkungen](#fragen)
3. [Module Description - What the module does and why it is useful](#module-description)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Overview

Dieses Modul bietet eine hochgradige Abdeckung der SoC Anforderungen für SSH, Server und Client, dar.

## Important
Zur Flexibilitaet sind einige Settings konfigurierbar, aber mit sicheren Default-Werten versehen. Bei Abweichung von den Defaultwerten kann die generelle SoC-Compliance nicht mehr
durch das Modul bereitgestellt werden und die Projekte müssen wieder selbst prüfen.

## Module Description

Das Modul kontrolliert sowohl die /etc/ssh/sshd_config, /etc/ssh/ssh_config, /etc/issue und /etc/motd.

### sshd_config

- SoC Requirements 1 - 12 werden ohne Einschränkungen erfüllt.
- SoC Requirements 13, 14, 17, 18 werden über Public Key Authentication erfüllt.
- SoC Requirement 15 wird per Default nicht erfüllt um bestehende Services im Betrieb nicht zu beeinflussen, ermöglicht aber durch Konfiguration die Compliance -> beim Modul zum Management der User muss hier jedoch die Location ebenfalls beachtet werden!
- SoC Requirement 16 muss projektindividuell gelöst werden.
- SOC Requirement 18 wird nicht zentral realisiert, aber ist eine sinnvolle Anforderung für die Serviceshell als Jumpserver.
- SoC Requirement 21 (der serverseitige Teil) wird ohne Einschränkung realisiert.

### ssh_config
- SoC Requirements 19, 20, 22 werden ohne Einschränkungen erfüllt.
- SoC Requirement 21 wird nicht direkt umgesetzt, sondern muss auf dem Sprungserver davor, der Serviceshell, realisiert werden.

## Usage

- Das Modul sollte 1-zu-1 in die Projekt-Repositories übernommen werden können.

### Usage ohne Puppet

- Die Templates ssh_config.erb und sshd_config.erb können, bis auf den Bereich "ListenAdress" und des "SFTP Subsystem" in der sshd_config.erb 1-zu-1 übernommen werden. Der Disclaimer mit dem Bezug auf Puppet sollte ebenfalls entfernt werden.

### Verifikation

- Die Verifikation des sicheren Moduls kann über Serverspec (s. Serverspec im Repo) oder Nessus Auditfile getestet werden.

## Reference

- SSH-Anforderungen stammen aus [PSA 07 2015](https://www.telekom.com/psa).

## Limitations

- Modul wurde erfolgreich gegen CentOS6, RHEL6, RHEL7 getestet.

## Development

- Aenderungen am Modul sollten auch im Serverspec Script secc_ssh_spec.rb nachgezogen werden.
