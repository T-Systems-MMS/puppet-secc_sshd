# AMCS SecC - OpenSSH Module - Version 1.1.1

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

Dieses Modul bietet eine hochgradige Abdeckung der SoC Anforderungen für SSH, Server und Client, dar.

##Important
Zur Flexibilitaet sind einige Settings konfigurierbar, aber mit sicheren Default-Werten versehen. Bei Abweichung von den Defaultwerten kann die generelle SoC-Compliance nicht mehr
durch das Modul bereitgestellt werden und die Projekte müssen wieder selbst prüfen.

##Module Description
Das Modul kontrolliert sowohl die /etc/ssh/sshd_config, /etc/ssh/ssh_config, /etc/issue und /etc/motd.

###sshd_config
- SoC Requirements 1 - 12 werden ohne Einschränkungen erfüllt.
- SoC Requirements 13, 14, 17, 18 werden über Public Key Authentication erfüllt.
- SoC Requirement 15 wird nicht direkt umgesetzt, sondern durch Puppet kontrolliert. (Module Users)
- SoC Requirement 16 muss projektindividuell gelöst werden.
- SOC Requirement 18 wird nicht zentral realisiert, aber ist eine sinnvolle Anforderung für die Serviceshell als Jumpserver.
- SoC Requirement 21 (der serverseitige Teil) wird ohne Einschränkung realisiert.

###ssh_config
- SoC Requirements 19, 20, 22 werden ohne Einschränkungen erfüllt.
- SoC Requirement 21 wird nicht direkt umgesetzt, sondern muss auf dem Sprungserver davor, der Serviceshell, realisiert werden.

##Usage
- Das Modul sollte 1-zu-1 in die Projekt-Repositories übernommen werden können.
###Usage ohne Puppet
- Die Templates ssh_config.erb und sshd_config.erb können, bis auf den Bereich "ListenAdress" und des "SFTP Subsystem" in der sshd_config.erb 1-zu-1 übernommen werden. Der Disclaimer mit dem Bezug auf Puppet sollte ebenfalls entfernt werden.
###Verifikation
- Die Verifikation des sicheren Moduls kann über Serverspec (s. Serverspec im Repo) oder Nessus Auditfile getestet werden.

##Reference
- SSH-Anforderungen stammen aus PSA 07 2015.

##Limitations
- Modul wurde erfolgreich gegen CentOS6, RHEL6, RHEL7, SLES11 und SLES12 getestet.

##Development
- Aenderungen am Modul sollten auch im Serverspec Script secc_ssh_spec.rb nachgezogen werden.

##Release Notes/Contributors/Etc
- Initialrelease.
- Vielen Dank an Markus Kaloski für die Übermittlung seiner gehärteten Version.
- 1.0.3: Roaming Feature aufgrund CVE-2016-0777 und CVE-2016-0778 deaktiviert.
- 1.1.0: Added Parameters (Admininterface - default first; AllowUsers, AllowGroups, DenyUser, DenyGroups, KexAlgorithm, Ciphers and MACs for more flexibility.
 - Adjusted KexAlgorithms from 'diffie-hellman-group-exchange-sha256' to 'diffie-hellman-group-exchange-sha256, diffie-hellman-group14-sha1' because SCB needs the latter.
- 1.1.1: Added ExplicitParameters for StrictMode and PrivilegeSeperation
 - Adjusted Ruby Version for Kitchen