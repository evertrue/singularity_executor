name             'singularity_executor'
maintainer       'EverTrue'
maintainer_email 'devops@evertrue.com'
license          'All rights reserved'
description      'Installs Singularity Executor'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.1.1'

supports 'ubuntu', '>= 14.04'

source_url 'https://github.com/evertrue/singularity_executor-cookbook' if respond_to?(:source_url)
issues_url 'https://github.com/evertrue/singularity_executor-cookbook/issues' if respond_to?(:issues_url)

depends 'java'
depends 'maven'
depends 'cron'
