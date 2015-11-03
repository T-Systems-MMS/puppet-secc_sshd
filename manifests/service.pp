# service status
class secc_sshd::service {

  service { 'sshd':
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    enable     => true,
    require    => Class['secc_sshd::install'],
  }

}
