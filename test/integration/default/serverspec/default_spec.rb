require 'spec_helper'

describe 'singularity_executor::default' do
  ['/usr/local/singularity/bin',
   '/var/lib/singularity/executor-tasks'].each do |dir|
    describe file dir do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'singularity' }
      it { is_expected.to be_grouped_into 'singularity' }
      it { is_expected.to be_mode 755 }
    end
  end

  %w(executor
     base
     s3base).each do |executor_conf|
    describe file "/etc/singularity.#{executor_conf}.yaml" do
      it { is_expected.to be_file }
    end
  end

  describe file '/etc/singularity.executor.yaml' do
    describe '#content' do
      subject { super().content }
      it { is_expected.to include 's3UploaderBucket: example' }
      it { is_expected.to include 'serviceLog: service.log' }
    end
  end

  describe file '/etc/singularity.base.yaml' do
    describe '#content' do
      subject { super().content }
      it { is_expected.to include 'loggingDirectory: "/var/log/singularity-executor"' }
    end
  end

  describe file '/etc/singularity.s3base.yaml' do
    describe '#content' do
      subject { super().content }
      it { is_expected.to include 'FAKE_ACCESS_KEY_ID' }
      it { is_expected.to include 'FAKE_SECRET_ACCESS_KEY' }
    end
  end

  describe file '/usr/local/singularity/bin/singularity-executor' do
    describe '#content' do
      subject { super().content }
      it { is_expected.to include '/usr/local/singularity/bin/SingularityExecutor' }
      it { is_expected.to include "-Xmx192M \\\n" }
      it { is_expected.to include "-test \\\n" }
    end
  end

  describe file '/usr/local/singularity/bin/SingularityExecutor-0.7.1-shaded.jar' do
    it { is_expected.to be_file }
    it { is_expected.to be_mode '755' }
    it { is_expected.to be_owned_by 'singularity' }
  end

  describe file '/usr/local/singularity/bin/SingularityExecutor' do
    it do
      is_expected.to be_linked_to '/usr/local/singularity/bin/' \
                                  'SingularityExecutor-0.7.1-shaded.jar'
    end
  end

  describe file '/usr/local/singularity/bin/SingularityS3Uploader-0.15.1.jar' do
    it { is_expected.to be_file }
  end
end
