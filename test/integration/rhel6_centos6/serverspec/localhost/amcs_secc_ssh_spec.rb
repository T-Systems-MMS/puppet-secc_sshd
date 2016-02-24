require 'spec_helper'

#print "os-array: "
#puts os

####
# disabled checks are only temp. disabled and have to be enabled to ensure compliance
####

# sshd config - check
describe file('/etc/ssh/sshd_config') do
  # Network
  its(:content) { should match /^Port 22$/ }
  its(:content) { should match /^AddressFamily inet$/ }
  its(:content) { should match /^UseDNS no/ }
  its(:content) { should_not match /^UseDNS yes/ }

  # Banner
  its(:content) { should match /^Banner \/etc\/issue$/ }
  its(:content) { should match /^PrintMotd yes$/ }

  # Req 1
  its(:content) { should match /^Protocol 2$/ }
  its(:content) { should_not match /^Protocol 1/ }

  # Req 2
  its(:content) { should match /^Ciphers aes256-ctr$/ }
  its(:content) { should match /^MACs hmac-sha2-512,hmac-sha2-256$/ }
  its(:content) { should match /^KexAlgorithms diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1$/ }

  # Req 3
  its(:content) { should match /^ListenAddress 1/ }
  its(:content) { should_not match /^ListenAddress 0.0.0.0/ }
  its(:content) { should_not match /^ListenAddress ::/ }

  # Req 6
  its(:content) { should match /^AllowTcpForwarding no$/ }

  # Req 7
  its(:content) { should match /^GatewayPorts no$/ }

  # Req 8
  its(:content) { should match /^X11Forwarding no$/ }
  its(:content) { should_not match /^X11Forwarding yes/ }
  its(:content) { should match /^X11UseLocalhost yes$/ }
  its(:content) { should_not match /^X11UseLocalhost no/ }

  # Req 9 and Req 21
  its(:content) { should match /^AllowAgentForwarding no$/ }
  its(:content) { should_not match /^AllowAgentForwarding yes/ }

  # Req 10
  its(:content) { should match /^PermitTunnel no$/ }
  its(:content) { should_not match /^PermitTunnel yes/ }

  # Req 11
  its(:content) { should match /^AllowUsers/ }
  its(:content) { should match /AllowGroups/ }

  # Req 12
  its(:content) { should match /^SyslogFacility AUTHPRIV$/ }
  its(:content) { should match /^LogLevel VERBOSE$/ }

  # Req 13,14,15,17,18
  its(:content) { should match /^PubKeyAuthentication yes$/ }
  its(:content) { should_not match /^PubKeyAuthentication no/ }
  its(:content) { should match /^PasswordAuthentication no$/ }
  its(:content) { should_not match /^PasswordAuthentication yes/ }
  its(:content) { should match /^RSAAuthentication yes$/ }
  its(:content) { should_not match /^RSAAuthentication no/ }
  its(:content) { should match /^ChallengeResponseAuthentication no$/ }
  its(:content) { should_not match /^ChallengeResponseAuthentication yes/ }
  its(:content) { should match /^PermitEmptyPasswords no$/ }
  its(:content) { should_not match /^PermitEmptyPasswords yes/ }
  its(:content) { should match /^PermitRootLogin without-password$/ }
  its(:content) { should_not match /^PermitRootLogin yes/ }
  its(:content) { should match /^AuthorizedKeysFile .ssh\/authorized_keys$/ }
  its(:content) { should_not match /^AuthorizedKeysFile \// }
  its(:content) { should match /^RhostsRSAAuthentication no$/ }
  its(:content) { should_not match /^RhostsRSAAuthentication yes/ }
  its(:content) { should match /^HostbasedAuthentication no$/ }
  its(:content) { should_not match /^HostbasedAuthentication yes/ }
  its(:content) { should match /^IgnoreRhosts yes$/ }
  its(:content) { should_not match /^IgnoreRhosts no/ }

  # Req 21
  its(:content) { should match /^AllowAgentForwarding no$/ }
  its(:content) { should_not match /^AllowAgentForwarding yes/ }
  
  # new adjustments
  its(:content) { should_not match /^UseRoaming no$/ }
  its(:content) { should_not match /^UseRoaming yes/ }
  
  its(:content) { should_not match /^HashKnownHosts yes$/ }
  its(:content) { should_not match /^HashKnownHosts no/ }
end

# sshd config - check
describe file('/etc/ssh/ssh_config') do
  # Req 19
  its(:content) { should match /^StrictHostKeyChecking ask$/ }
  its(:content) { should_not match /^StrictHostKeyChecking no/ }

  # Req 20
  its(:content) { should match /^ForwardAgent no$/ }
  its(:content) { should_not match /^ForwardAgent yes/ }
  its(:content) { should match /^ForwardX11 no$/ }
  its(:content) { should_not match /^ForwardX11 yes/ }
  its(:content) { should match /^ForwardX11Trusted no$/ }
  its(:content) { should_not match /^ForwardX11Trusted yes/ }
end
