require 'spec_helper'

describe 'singularity_executor::cleanup' do
  describe file '/usr/local/bin/singularity-executor-cleanup' do
    it { is_expected.to be_file }
  end

  describe file '/usr/local/bin/singularity-executor-cleanup' do
    it { is_expected.to be_mode 755 }
  end

  describe command '/usr/local/bin/singularity-executor-cleanup' do
    its(:exit_status) { is_expected.to be 0 }
  end

  describe file '/etc/singularity.executor.cleanup.yaml' do
    it { is_expected.to be_file }
  end
end
