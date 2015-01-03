# == Class: puppet::install
#
# Installs the required puppet packages
#
class puppet::install {

  package { 'puppet':
    ensure => $::puppet::puppet_package_ensure,
    name   => $::puppet::puppet_package_name,
  }

  if $::puppet::server {
    package { 'puppetserver':
      ensure => $::puppet::server_package_ensure,
      name   => $::puppet::server_package_name,
    }
  }

}
