class puppet::params {

  case $::lsbdistid {
    'Ubuntu': {
      $config_file    = '/etc/puppet/puppet.conf'
      $default_file   = '/etc/default/puppetserver'
      $package_name   = 'puppet'
      $package_common = 'puppet-common'
      $server_package = 'puppetserver'
      $server_service = 'puppetserver'
    }
  }

}
