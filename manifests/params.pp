class puppet::params {

  $config_file                  = '/etc/puppet/puppet.conf'
  $puppet_package_name          = 'puppet'
  $puppet_package_ensure        = 'present'
  $puppet_common_package_name   = 'puppet-common'
  $puppet_master_package        = 'puppetmaster'
  $puppet_master_common_package = 'puppetmaster-common'

}
