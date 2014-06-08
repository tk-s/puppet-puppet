class puppet::params {

  case $::lsbdistid {
    'Ubuntu': {
      $config_file    = '/etc/puppet/puppet.conf'
      $package_name   = 'puppet'
      $package_ensure = 'latest'
      $master_package = 'puppetmaster'
      $master_service = 'puppetmaster'
    }
  }

}
