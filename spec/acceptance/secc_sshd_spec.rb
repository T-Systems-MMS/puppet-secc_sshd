require 'spec_helper_acceptance'

describe 'Class secc_sshd' do
  context 'with default sshd and ssh config' do

    command("service sshd stop")

    let(:manifest) {
    <<-EOS
      class { 'secc_sshd': }
    EOS
    }

    it 'should run without errors' do
      expect(apply_manifest(manifest, :catch_failures => true).exit_code).to eq(2)
    end

    it 'should re-run without changes' do
      expect(apply_manifest(manifest, :catch_changes => true).exit_code).to be_zero
    end

    describe package('openssh-server') do
      it { is_expected.to be_installed }
    end

    describe service('sshd') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe file('/etc/ssh/sshd_config') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode 600 }
      its(:content) { is_expected.to include 'Port 22' }
      its(:content) { is_expected.to include 'AddressFamily inet' }
      its(:content) { is_expected.to include 'UseDNS no' }
      its(:content) { is_expected.to include 'Protocol 2' }
      its(:content) { is_expected.to include 'Ciphers aes256-ctr' }
      its(:content) { is_expected.to include 'MACs hmac-sha2-512,hmac-sha2-256' }
      its(:content) { is_expected.to include 'KexAlgorithms diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1' }
      its(:content) { is_expected.to include 'AllowTcpForwarding no' }
      its(:content) { is_expected.to include 'GatewayPorts no' }
      its(:content) { is_expected.to include 'X11Forwarding no' }
      its(:content) { is_expected.to include 'X11UseLocalhost yes' }
      its(:content) { is_expected.to include 'AllowAgentForwarding no' }
      its(:content) { is_expected.to include 'PermitTunnel no' }
      its(:content) { is_expected.to include 'AllowUsers root rootuser' }
      its(:content) { is_expected.to include 'SyslogFacility AUTHPRIV' }
      its(:content) { is_expected.to include 'LogLevel VERBOSE' }
      its(:content) { is_expected.to include 'PasswordAuthentication no' }
      its(:content) { is_expected.to include 'RSAAuthentication yes' }
      its(:content) { is_expected.to include 'ChallengeResponseAuthentication no' }
      its(:content) { is_expected.to include 'PermitEmptyPasswords no' }
      its(:content) { is_expected.to include 'PubKeyAuthentication yes' }
      its(:content) { is_expected.to include 'PermitRootLogin without-password' }
      its(:content) { is_expected.to include 'AuthorizedKeysFile .ssh/authorized_keys' }
      its(:content) { is_expected.to include 'RhostsRSAAuthentication no' }
      its(:content) { is_expected.to include 'HostbasedAuthentication no' }
      its(:content) { is_expected.to include 'IgnoreRhosts yes' }
      its(:content) { is_expected.to include 'StrictModes yes' }
      its(:content) { is_expected.to include 'UsePrivilegeSeparation yes' }
      its(:content) { is_expected.to include 'Banner /etc/issue' }
      its(:content) { is_expected.to include 'PrintMotd yes' }
      its(:content) { is_expected.to include 'GSSAPIAuthentication no' }
      its(:content) { is_expected.to include 'GSSAPICleanupCredentials yes' }
      its(:content) { is_expected.to include 'UsePAM yes' }
      its(:content) { is_expected.to include 'AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES' }
      its(:content) { is_expected.to include 'AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT' }
      its(:content) { is_expected.to include 'AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE' }
      its(:content) { is_expected.to include 'AcceptEnv XMODIFIERS' }
      its(:content) { is_expected.to include 'Subsystem       sftp    /usr/libexec/openssh/sftp-server' }
      its(:content) { is_expected.to include 'HostKey /etc/ssh/ssh_host_rsa_key' }
      its(:content) { is_expected.to include 'KeyRegenerationInterval 1h' }
      its(:content) { is_expected.to include 'ServerKeyBits 2048' }
      its(:content) { is_expected.to include 'LoginGraceTime 2m' }
      its(:content) { is_expected.to include 'TCPKeepAlive yes' }
      its(:content) { is_expected.to include 'Compression delayed' }
      its(:content) { is_expected.to include 'ClientAliveInterval 120' }
      its(:content) { is_expected.to include 'ClientAliveCountMax 3' }
    end

    describe file('/etc/ssh/ssh_config') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to include 'Host *' }
      its(:content) { is_expected.to include 'GSSAPIAuthentication no' }
      its(:content) { is_expected.to include 'SendEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES' }
      its(:content) { is_expected.to include 'SendEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT' }
      its(:content) { is_expected.to include 'SendEnv LC_IDENTIFICATION LC_ALL LANGUAGE' }
      its(:content) { is_expected.to include 'SendEnv XMODIFIERS' }
      its(:content) { is_expected.to include 'StrictHostKeyChecking ask' }
      its(:content) { is_expected.to include 'ForwardAgent no' }
      its(:content) { is_expected.to include 'ForwardX11 no' }
      its(:content) { is_expected.to include 'ForwardX11Trusted no' }
      its(:content) { is_expected.to include 'GatewayPorts no' }
      its(:content) { is_expected.to include 'Ciphers aes256-ctr' }
      its(:content) { is_expected.to include 'MACs hmac-sha2-512,hmac-sha2-256' }
      its(:content) { is_expected.to include 'KexAlgorithms diffie-hellman-group-exchange-sha256' }
      its(:content) { is_expected.to include 'UseRoaming no' }
      its(:content) { is_expected.to include 'HashKnownHosts yes' }
    end

  end
end
