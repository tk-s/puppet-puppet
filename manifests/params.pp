class puppet::params {

  $config_file    = '/etc/puppet/puppet.conf'
  $agent_package  = 'puppet'
  $master_package = 'puppetmaster'
  $package_ensure = 'latest'

}
