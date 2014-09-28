class puppet::params {

  case $::lsbdistid {
    'Ubuntu': {
      $config_file    = '/etc/puppet/puppet.conf'
      $package_name   = 'puppet'
      $package_common = 'puppet-common'
      $package_ensure = 'latest'
      $master_package = 'puppetmaster'
      $master_common  = 'puppetmaster-common'
      $master_service = 'puppetmaster'
    }
  }

}
