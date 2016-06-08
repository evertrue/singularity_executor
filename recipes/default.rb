#
# Cookbook Name:: singularity_executor
# Recipe:: default
#
# Copyright (c) 2016 Evertrue, Inc, All Rights Reserved.
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

user node['singularity_executor']['user'] do
  supports manage_home: true
  home node['singularity_executor']['home']
end

["#{node['singularity_executor']['home']}/bin",
 "#{node['singularity_executor']['data_dir']}/executor-tasks",
 node['singularity_executor']['log_dir']].each do |dir|
  directory dir do
    owner     node['singularity_executor']['user']
    group     node['singularity_executor']['user']
    mode      0755
    recursive true
    action    :create
  end
end

include_recipe 'maven'

execute 'truststore configure' do
  command '/var/lib/dpkg/info/ca-certificates-java.postinst configure'
end

maven 'SingularityExecutor' do
  group_id   'com.hubspot'
  classifier 'shaded'
  version    node['singularity_executor']['version']
  dest       "#{node['singularity_executor']['home']}/bin"
  mode       0755
  owner      node['singularity_executor']['user']
end

link "#{node['singularity_executor']['home']}/bin/SingularityExecutor" do
  to "#{node['singularity_executor']['home']}/bin/SingularityExecutor-" \
     "#{node['singularity_executor']['version']}-shaded.jar"
end

s3_creds = data_bag_item('secrets', 'aws_credentials')['Singularity']
node.set['singularity_executor']['s3base_yaml']['s3AccessKey'] = s3_creds['access_key_id']
node.set['singularity_executor']['s3base_yaml']['s3SecretKey'] = s3_creds['secret_access_key']

%w(executor
   base
   s3base).each do |executor_conf|
  file "/etc/singularity.#{executor_conf}.yaml" do
    owner     node['singularity_executor']['user']
    group     node['singularity_executor']['user']
    content JSON.parse(node['singularity_executor']["#{executor_conf}_yaml"].to_json).to_yaml
    mode 0600
  end
end

template "#{node['singularity_executor']['home']}/bin/singularity-executor" do
  mode 0755
end
