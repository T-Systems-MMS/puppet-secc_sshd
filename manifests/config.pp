# config
class secc_sshd::config (
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
  $sshd_ChallengeResponseAuthentication,
  $sshd_match_users,
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

}
