require 'spec_helper_acceptance'

describe 'Class secc_sshd' do
  context 'with custom MAtch User directive' do
    run_shell('pkill -F /var/run/sshd.pid; service sshd start')

    manifest = <<-EOS
      class { 'secc_sshd':
        sshd_ChallengeResponseAuthentication  => 'yes',
        sshd_PermitRootLogin => 'yes',
        sshd_match_users => {'testuser' => {
                                  'PasswordAuthentication' => 'yes #testuser',
                                  },
                                },
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
      its(:content) { is_expected.to include 'Match User testuser' }
      its(:content) { is_expected.to include '  PasswordAuthentication yes #testuser' }
    end
  end
end
