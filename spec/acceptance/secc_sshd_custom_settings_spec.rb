require 'spec_helper_acceptance'

describe 'Class secc_sshd' do
  context 'with custom sshd and ssh config' do
    run_shell('pkill -F /var/run/sshd.pid; service sshd start')

    manifest = <<-EOS
      class { 'secc_sshd':
        ext_listen                                => ['127.0.0.1', '0.0.0.0'],
        ext_sshd_AllowUsers                       => 'root test',
        ext_sshd_AllowGroups                      => 'root test',
        ext_sshd_DenyUsers                        => 'test_deny',
        ext_sshd_DenyGroups                       => 'test_deny',
        ext_sshd_ChallengeResponseAuthentication  => 'yes',
        ext_sshd_PermitRootLogin                  => 'yes',
        ext_ssh_ForwardAgent                      => 'yes',
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
      its(:content) { is_expected.to include 'ListenAddress 127.0.0.1' }
      its(:content) { is_expected.to include 'ListenAddress 0.0.0.0' }
      its(:content) { is_expected.to include 'AllowUsers root test' }
      its(:content) { is_expected.to include 'AllowGroups root test' }
      its(:content) { is_expected.to include 'DenyUsers test_deny' }
      its(:content) { is_expected.to include 'DenyGroups test_deny' }
      its(:content) { is_expected.to include 'ChallengeResponseAuthentication yes' }
    end

    describe file('/etc/ssh/ssh_config') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to include 'ForwardAgent yes' }
    end
  end
end
