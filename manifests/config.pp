# config
class secc_sshd::config {

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

  file { '/etc/motd':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('secc_sshd/default_motd.erb'),
  }
}
