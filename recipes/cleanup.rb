#
# Cookbook Name:: singularity_executor
# Recipe:: cleanup
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

jar_file = "#{node['singularity_executor']['home']}/bin/" \
  "SingularityExecutorCleanup-#{node['singularity_executor']['version']}-shaded.jar"

remote_file jar_file do
  source 'http://search.maven.org/remotecontent?filepath=' \
    'com/hubspot/SingularityExecutorCleanup/' \
    "#{node['singularity_executor']['version']}/#{File.basename jar_file}"
  checksum node['singularity_executor']['checksum']
end

template '/usr/local/bin/singularity-executor-cleanup' do
  mode 0o755
  variables jar_file: jar_file
end

cron_d 'singularity-executor-cleanup' do
  command '/usr/local/bin/singularity-executor-cleanup | logger -p cron.info'
  minute 0
end

search_str = node['singularity_executor']['singularity_host_search_str'] +
  " AND chef_environment:#{node.chef_environment}"

singularity_hosts = search(
  :node,
  search_str,
  filter_result: { 'fqdn' => %w(fqdn) }
)

if singularity_hosts.empty?
  all_nodes = search(:node, '*:*')
  fail "No Singularity hosts discovered using search: #{search_str} (all nodes: #{all_nodes})"
end

node.default['singularity_executor']['cleanup_yaml']['singularityHosts'] =
  singularity_hosts.map { |n| "#{n['fqdn']}:7092" }

file '/etc/singularity.executor.cleanup.yaml' do
  owner 'singularity'
  group 'singularity'
  content JSON.parse(node['singularity_executor']['cleanup_yaml'].to_json).to_yaml
  mode 0o644
end

directory node['singularity_executor']['cleanup_yaml']['executorCleanupResultsDirectory'] do
  recursive true
end

logrotate_app 'singularity-executor-cleanup' do
  path "#{node['singularity_executor']['log_dir']}/singularity-executor-cleanup.log"
  frequency 'daily'
  rotate 7
end
