require 'spec_helper_acceptance'

describe 'Class secc_sshd' do
  context 'with custom sshd and ssh config' do

    command("service sshd stop")

    let(:manifest) {
    <<-EOS
      class { 'secc_sshd':
        hiera(sshd_AllowUsers) => '',
        hiera(sshd_AllowGroups) => '',
      }
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
      its(:content) { is_expected.to_not 'AllowUsers' }
      its(:content) { is_expected.to_not 'AllowGroups' }
    end
  end
end
