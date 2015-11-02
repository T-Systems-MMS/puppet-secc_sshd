# config
class secc_sshd::ssh_config {

  file { '/etc/ssh/ssh_config':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('secc_sshd/ssh_config.erb'),
    require => Class['secc_sshd::install'],
  }

}
