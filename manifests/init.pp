    # SecC Linux SSH Hardening
class secc_sshd (
  $listen                               = [$::ipaddress],
  $admin_interface                      = undef,
  $sshd_AllowUsers                      = 'root rootuser',
  $sshd_AllowGroups                     = '',
  $sshd_DenyUsers                       = '',
  $sshd_DenyGroups                      = '',
  $sshd_KexAlgorithms                   = 'diffie-hellman-group-exchange-sha256',
  $sshd_AllowTcpForwarding              = 'no',
  $sshd_AllowAgentForwarding            = 'no',
  $sshd_Ciphers                         = 'aes256-ctr',
  $sshd_MACs                            = 'hmac-sha2-512,hmac-sha2-256',
  $sshd_AuthorizedKeysFile              = '.ssh/authorized_keys',
  $sshd_AuthorizedKeysCommand           = undef,
  $sshd_AuthorizedKeysCommandUser       = 'nobody',
  $sshd_ChallengeResponseAuthentication = 'no',
  $sshd_PermitRootLogin                 = 'without-password',
  $ssh_ForwardAgent                     = 'no',
  $ssh_KexAlgorithms                    = 'diffie-hellman-group-exchange-sha256',
  $ssh_Ciphers                          = 'aes256-ctr',
  $ssh_MACs                             = 'hmac-sha2-512,hmac-sha2-256',
  $sshd_match_users                     = undef,
) {

  if ($admin_interface) {
    fail('using variable admin_interface is deprecated, cancel puppet run | please use listen and specify an IP there (e.g. 172.29.0.10)')
  }

  include secc_sshd::install

  class { 'secc_sshd::config':
    listen                               => $listen,
    sshd_AllowUsers                      => $sshd_AllowUsers,
    sshd_AllowGroups                     => $sshd_AllowGroups,
    sshd_DenyUsers                       => $sshd_DenyUsers,
    sshd_DenyGroups                      => $sshd_DenyGroups,
    sshd_KexAlgorithms                   => $sshd_KexAlgorithms,
    sshd_AllowTcpForwarding              => $sshd_AllowTcpForwarding,
    sshd_AllowAgentForwarding            => $sshd_AllowAgentForwarding,
    sshd_Ciphers                         => $sshd_Ciphers,
    sshd_MACs                            => $sshd_MACs,
    sshd_AuthorizedKeysFile              => $sshd_AuthorizedKeysFile,
    sshd_AuthorizedKeysCommand           => $sshd_AuthorizedKeysCommand,
    sshd_AuthorizedKeysCommandUser       => $sshd_AuthorizedKeysCommandUser,
    sshd_ChallengeResponseAuthentication => $sshd_ChallengeResponseAuthentication,
    sshd_PermitRootLogin                 => $sshd_PermitRootLogin,
    sshd_match_users                     => $sshd_match_users,
    require                              => Class['secc_sshd::install'],
    notify                               => Class['secc_sshd::service'],
  }

  include secc_sshd::service

  class { 'secc_sshd::ssh_config':
    ssh_ForwardAgent  => $ssh_ForwardAgent,
    ssh_KexAlgorithms => $ssh_KexAlgorithms,
    ssh_Ciphers       => $ssh_Ciphers,
    ssh_MACs          => $ssh_MACs,
  }
}
