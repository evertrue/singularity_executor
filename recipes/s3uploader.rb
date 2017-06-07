#
# Cookbook Name:: singularity_executor
# Recipe:: s3uploader
#
# Copyright (c) 2017 Evertrue, Inc, All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'java'

user 'singularity' do
  supports manage_home: true
  home node['singularity_s3uploader']['home']
end

["#{node['singularity_s3uploader']['home']}/bin"].each do |dir|
  directory dir do
    owner     'singularity'
    group     'singularity'
    recursive true
  end
end

jar_file = "#{node['singularity_s3uploader']['home']}/bin/" \
  "SingularityS3Uploader-#{node['singularity_s3uploader']['version']}-shaded.jar"

remote_file jar_file do
  source 'http://search.maven.org/remotecontent?filepath=' \
    'com/hubspot/SingularityS3Uploader/' \
    "#{node['singularity_s3uploader']['version']}/#{File.basename jar_file}"
  checksum node['singularity_s3uploader']['checksum']
end

if node['platform_version'].to_i < 16
  directory node['singularity_s3uploader']['log_dir']

  template '/etc/init/singularity-s3uploader.conf' do
    source 'singularity-s3uploader-upstart.erb'
    variables jar_file: jar_file
  end

  service 'singularity-s3uploader' do
    provider Chef::Provider::Service::Upstart
    action %i(start enable)
  end
else
  template '/etc/systemd/system/singularity-s3uploader.service' do
    source 'singularity-s3uploader-systemd.erb'
    variables jar_file: jar_file
  end

  service 'singularity-s3uploader' do
    action %i(start enable)
  end
end

unless (creds = SingularityS3Uploader::Helpers.iam_credentials)
  fail 's3uploader requires an IAM profile'
end

node.override['singularity_executor']['s3uploader_yaml']['s3']['s3AccessKey'] =
  creds['AccessKeyId']
node.override['singularity_executor']['s3uploader_yaml']['s3']['s3SecretKey'] =
  creds['SecretAccessKey']
