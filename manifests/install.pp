# install
class secc_sshd::install {

  package { 'openssh':
    ensure => latest,
  }

}
