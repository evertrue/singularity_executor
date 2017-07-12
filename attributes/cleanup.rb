default['singularity_executor']['cleanup_java_args'] = %w(-Xmx128M -Xms128M)
default['singularity_executor']['cleanup_yaml'] = {
  'executorCleanup' => {
    'defaultS3Bucket' => 'et-logstash',
    's3KeyFormat' => 'singularitys3uploader/%requestId/%Y/%m/%taskId_%index-%s-%filename',
    's3UploaderAdditionalFiles' => [
      { 'filename' => 'stdout' },
      { 'filename' => 'stderr' }
    ]
  },
  'singularityContextPath' => 'api',
  'executorCleanupResultsDirectory' => '/tmp/singularity-executor-cleanup-results'
}
default['singularity_executor']['singularity_host_search_str'] =
  "recipes:et_singularity\\:\\:default"
