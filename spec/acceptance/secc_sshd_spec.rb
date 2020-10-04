require 'spec_helper_acceptance'

describe 'Class secc_sshd' do
  context 'with default sshd and ssh config' do
    run_shell('pkill -F /var/run/sshd.pid; service sshd start')

    manifest = <<-EOS
      class { 'secc_sshd':
        sshd_ChallengeResponseAuthentication  => 'yes',
        sshd_PermitRootLogin                  => 'yes',
      }
    EOS

    it 'runs without errors' do
      idempotent_apply(manifest)
    end

    describe package('openssh-server') do
      it { is_expected.to be_installed }
    end

    describe service('sshd') do
      if os[:family] == 'redhat' && os[:release].to_i >= 7
        it { is_expected.to be_enabled.under('systemd') }
        it { is_expected.to be_running.under('systemd') }
      else
        it { is_expected.to be_enabled }
        it { is_expected.to be_running }
      end
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
      its(:content) { is_expected.to include 'KexAlgorithms diffie-hellman-group-exchange-sha256' }
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
      # TODO: not possible, because of testing
      # its(:content) { is_expected.to include 'ChallengeResponseAuthentication no' }
      its(:content) { is_expected.to include 'PermitEmptyPasswords no' }
      its(:content) { is_expected.to include 'PubKeyAuthentication yes' }
      # TODO: not possible, because of testing
      # its(:content) { is_expected.to include 'PermitRootLogin without-password' }
      its(:content) { is_expected.to include 'AuthorizedKeysFile .ssh/authorized_keys' }
      its(:content) { is_expected.to include 'HostbasedAuthentication no' }
      its(:content) { is_expected.to include 'IgnoreRhosts yes' }
      its(:content) { is_expected.to include 'StrictModes yes' }
      if os[:family] == 'redhat' && os[:release].to_i < 8
        its(:content) { is_expected.to include 'UsePrivilegeSeparation yes' }
      end
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
      its(:content) { is_expected.to include 'LoginGraceTime 1m' }
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
      its(:content) { is_expected.to include 'VerifyHostKeyDNS ask' }
      its(:content) { is_expected.to include 'ForwardAgent no' }
      its(:content) { is_expected.to include 'ForwardX11 no' }
      its(:content) { is_expected.to include 'ForwardX11Trusted no' }
      its(:content) { is_expected.to include 'GatewayPorts no' }
      its(:content) { is_expected.to include 'Ciphers aes256-ctr' }
      its(:content) { is_expected.to include 'MACs hmac-sha2-512,hmac-sha2-256' }
      its(:content) { is_expected.to include 'KexAlgorithms diffie-hellman-group-exchange-sha256' }
      if os[:family] == 'redhat' && os[:release].to_i < 7
        its(:content) { is_expected.to include 'UseRoaming no' }
      end
      its(:content) { is_expected.to include 'HashKnownHosts yes' }
    end

    describe run_shell('puppet facts | grep secc_sshd_info -A3') do
      its(:stdout) { is_expected.to include '    "secc_sshd_info"' }
      its(:stdout) { is_expected.to include '      "version": "openssh' }
      its(:stdout) { is_expected.to include '      "last_update": "2020' }
      its(:stdout) { is_expected.to include '      "last_update_unixtime": "1' }
    end

    describe run_shell('/usr/sbin/sshd -t') do
      its(:stderr) { is_expected.not_to include 'Deprecated option' }
    end

    describe run_shell('ssh -v localhost id 2>&1 | grep "Deprecated option"', expect_failures: true) do
      its(:stdout) { is_expected.not_to include 'Deprecated option' }
    end

    describe run_shell('awk \'$5 < 2048\' /etc/ssh/moduli | grep -q ^') do
      its(:exit_status) { is_expected.to eq 0 }
    end

    describe run_shell('awk \'$5 >= 2048\' /etc/ssh/moduli | grep -q " 3071 "') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
