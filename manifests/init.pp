# SecC Linux SSH Hardening
class secc_sshd {

  include secc_sshd::install

  include secc_sshd::config

  include secc_sshd::service

  include secc_sshd::ssh_config

}
