name             'opencv'
maintainer       'Jeff Byrnes'
maintainer_email 'thejeffbyrnes@gmail.com'
license          'Apache-2.0'
description      'Builds and installs opencv'
version          '1.3.2'

source_url 'https://github.com/jeffbyrnes/opencv-cookbook'
issues_url 'https://github.com/jeffbyrnes/opencv-cookbook/issues'

chef_version '>= 14.1.1'

supports 'ubuntu', '= 18.04'

depends 'ark', '~> 5.0'
