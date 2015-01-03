# == Class: puppet::service
#
# Manage the puppet services
#
class puppet::service {

  if $::puppet::agent and $::puppet::agent_service_mode == 'daemon' {
    service { 'puppet':
      ensure  => $::puppet::agent_service_ensure,
      enable  => $::puppet::agent_service_enable,
      name    => $::puppet::agent_service_name,
      require => Package['puppet'],
    }
  }

  if $::puppet::server {
    service { 'puppetserver':
        ensure => $::puppet::server_service_ensure,
        enable => $::puppet::server_service_enable,
        name   => $::puppet::server_service_name,
    }
  }

}
