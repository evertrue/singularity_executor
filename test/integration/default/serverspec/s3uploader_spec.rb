require 'spec_helper'

describe 'singularity_executor::s3uploader' do
  describe service 'singularity-s3uploader' do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe file '/etc/singularity.s3uploader.yaml' do
    let(:s3uploader) { YAML.load_file '/etc/singularity.s3uploader.yaml' }

    it('set the right bucket') { expect(s3uploader['s3']['s3Bucket']).to eq 'et-logstash' }
    it('set the right key format') do
      expect(s3uploader['s3']['s3KeyFormat']).to eq(
        'singularitys3uploader/%requestId/%Y/%m/%taskId_%index-%s-%filename'
      )
    end
    it('set an s3AccessKey') { expect(s3uploader['s3']['s3AccessKey']).to_not be_nil }
    it('s3AccessKey is not empty') { expect(s3uploader['s3']['s3AccessKey']).to_not eq '' }
    it('set an s3SecretKey') { expect(s3uploader['s3']['s3SecretKey']).to_not be_nil }
    it('s3SecretKey is not empty') { expect(s3uploader['s3']['s3SecretKey']).to_not eq '' }
  end
end
