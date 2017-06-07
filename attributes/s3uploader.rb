default['singularity_s3uploader']['version'] = '0.15.1'
default['singularity_s3uploader']['checksum'] =
  'b730d0385b53cc83d436ba51a39f34df819bc112d9691f5a776f27d0962e9fa2'

default['singularity_s3uploader']['home'] = '/usr/local/singularity'
default['singularity_s3uploader']['java_args'] = %w(-Xmx128M -Xms128M)
default['singularity_s3uploader']['log_dir'] = '/var/log/singularity-s3uploader'

default['singularity_executor']['s3uploader_yaml'] = {
  's3' => {
    's3Bucket' => 'et-logstash',
    's3KeyFormat' => 'singularitys3uploader/%requestId/%Y/%m/%taskId_%index-%s-%filename'
  }
}
