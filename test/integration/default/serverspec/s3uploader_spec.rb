require 'spec_helper'

describe 'singularity_executor::s3uploader' do
  describe service 'singularity-s3uploader' do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end
end
