default['singularity_executor']['version'] = '0.15.1'

default['singularity_executor']['user'] = 'singularity'
default['singularity_executor']['home'] = '/usr/local/singularity'

default['singularity_executor']['data_dir'] = '/var/lib/singularity'
default['singularity_executor']['log_dir'] = '/var/log/singularity-executor'

default['singularity_executor']['extra_args'] = %w(-Xmx128M)

default['singularity_executor']['executor_yaml'] = {
  'defaultRunAsUser' => node['singularity_executor']['user'],
  'globalTaskDefinitionDirectory' => '/var/lib/singularity/executor-tasks',
  's3UploaderBucket' => nil,
  's3UploaderKeyPattern' => '/singularity/executor/tasks/',
  'taskAppDirectory' => '.',
  'serviceLog' => 'service.log'
}

default['singularity_executor']['base_yaml'] = {
  'logWatcherMetadataDirectory' => '.',
  's3UploaderMetadataDirectory' => '.',
  'loggingDirectory' => node['singularity_executor']['log_dir'],
  'loggingLevel' => {
    'com.hubspot' => 'INFO'
  }
}

default['singularity_executor']['s3base_yaml'] = {
  'artifactCacheDirectory' => '.'
}

default['java']['jdk_version'] = '8'
default['java']['set_default'] = true
default['java']['ark_timeout'] = 10
default['java']['ark_retries'] = 3
