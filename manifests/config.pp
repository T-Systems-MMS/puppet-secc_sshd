# config
class secc_sshd::config (
  $admininterface_nr,
  $admininterface_xen0,
  $setListenAddress,
  $sshd_AllowUsers,
  $sshd_AllowGroups,
  $sshd_DenyUsers,
  $sshd_DenyGroups,
  $sshd_KexAlgorithms,
  $sshd_Ciphers,
  $sshd_MACs,
  $servicename
) {

  if ( $setListenAddress ) {
    if ( $::virtual == 'xen0' ) {
      $string = "@ipaddress_${admininterface_xen0}"
      $adminip = inline_template("<%= ${string} %>")
    }
    else {
      $ifs = split($::interfaces, ',')
      $string = "@ipaddress_${ifs[$admininterface_nr]}"
      $adminip = inline_template("<%= ${string} %>")
    }
  }

  file { '/etc/ssh/sshd_config':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('secc_sshd/sshd_config.erb'),
    require => Class['secc_sshd::install'],
    notify  => Class['secc_sshd::service'],
  }

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
