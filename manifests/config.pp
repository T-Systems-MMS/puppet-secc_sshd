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
  $sshd_PermitRootLogin,
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

  exec { 'delete small moduli':
    path     => '/usr/bin:/usr/sbin:/bin',
    provider => shell,
    command  => 'awk \'$5 >= 2048\' /etc/ssh/moduli > /etc/ssh/moduli.new ; [ -r /etc/ssh/moduli.new -a -s /etc/ssh/moduli.new ] && mv /etc/ssh/moduli.new /etc/ssh/moduli || true',
    onlyif   => 'test `awk \'$5 < 2048\' /etc/ssh/moduli | wc -c` -gt 0',
    require  => Class['secc_sshd::install'],
    notify   => Class['secc_sshd::service'],
  }

}
