# == Class: puppet::params
#
# OS/Distro-specific and Default settings
#
class puppet::params {

  # OS/Distro-specific Settings
  case $::osfamily {
    'Debian': {
      $config_file         = '/etc/puppet/puppet.conf'
      $puppet_package_name = 'puppet'
      $agent_service_name  = 'puppet'
      $server_package_name = 'puppetserver'
      $server_service_name = 'puppetserver'
      $server_default_file = '/etc/default/puppetserver'
    }
    default: {
      notify { "There are no params for ${::lsbdistid} yet.": }
    }
  }

  # All other settings

  ## package
  $manage_repo           = true
  $puppet_package_ensure = 'present'
  $server_package_ensure = 'present'

  ## main
  $main_settings = {}

  ## agent
  $agent                = true
  $agent_settings       = {}
  $agent_service_mode   = 'daemon'
  $agent_service_ensure = 'running'
  $agent_service_enable = true

  ## master/server
  $server                  = false
  $master_settings         = {}
  $server_default_settings = {}
  $server_service_ensure   = 'running'
  $server_service_enable   = true

}
