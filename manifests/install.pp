# install
class secc_sshd::install {
  
  # XCP is not a standard operatingsystem type for puppet
  # so there is not standard package provider definied
  # this fixes the problem, until puppet will define a standard package provider for "XCP"

  if $::operatingsystem == 'XCP' {
    package { 'openssh':
    # we set it to installed, because xcp-ng will handle the updates of sshd by it self
    ensure   => installed,
    provider => yum,
    }
  }
  else {
    package { 'openssh':
    ensure => latest,
    }
  }
}
