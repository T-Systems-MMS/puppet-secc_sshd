# config
class secc_sshd::config (
  $issue_banner,
  $listen,
  $sshd_AllowUsers,
  $sshd_AllowGroups,
  $sshd_DenyUsers,
  $sshd_DenyGroups,
  $sshd_KexAlgorithms,
  $sshd_AllowTcpForwarding,
  $sshd_AllowAgentForwarding,
  $sshd_Ciphers,
  $sshd_MACs,
  $sshd_AuthorizedKeysFile,
  $sshd_AuthorizedKeysCommand,
  $sshd_AuthorizedKeysCommandUser,
  $servicename
) {

  file { '/etc/ssh/sshd_config':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('secc_sshd/sshd_config.erb'),
    require => Class['secc_sshd::install'],
    notify  => Class['secc_sshd::service'],
  }

  if $issue_banner {
    file { '/etc/issue':
      ensure  => present,
      mode    => '0644',
      replace => true,
      owner   => 'root',
      group   => 'root',
      content => template('secc_sshd/issue_banner.erb'),
      require => Class['secc_sshd::install'],
      notify  => Class['secc_sshd::service'],
    }
  } else {
    file { '/etc/issue':
      ensure  => absent,
    }
  }

  file { '/etc/issue.net':
    ensure  => absent,
  }

  file { '/etc/motd':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('secc_sshd/default_motd.erb'),
  }

}
