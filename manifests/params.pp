class puppet::params {

  $config_file    = '/etc/puppet/puppet.conf'
  $package_name   = 'puppet'
  $package_ensure = 'latest'
  $master_package = 'puppetmaster'

}
