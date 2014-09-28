class puppet::master (
  $settings,
  $servertype     = 'standalone',
  $master_package = $::puppet::params::master_package,
  $package_ensure = $::puppet::params::package_ensure,
  $master_service = $::puppet::params::master_service,
  $config_file    = $::puppet::params::config_file,
) inherits puppet::params {

  include puppet

  $settings.each |$setting, $value| {
    ini_setting { "${config_file} master/${setting}":
      ensure  => present,
      path    => $config_file,
      section => 'master',
      setting => $setting,
      value   => $value,
      tag     => 'puppet-config',
      require => Class['puppet'],
    }
  }

  if has_key($settings, 'reportdir') {
    file { $settings['reportdir']:
      ensure  => directory,
      recurse => true,
      owner   => 'puppet',
      group   => 'puppet',
      mode    => '0640',
    }
  }

  package { 'puppet-master':
    name    => $master_package,
    ensure  => $package_ensure,
  }

  if $puppet::params::master_common {
    package { 'puppetmaster-common':
      name   => $puppet::params::puppetmaster_common,
      ensure => $package_ensure,
      before => Package['puppet-master'],
    }
  }

  case $servertype {
    'passenger': {
      include puppet::master::passenger
    }
    'nginx': {
      include puppet::master::nginx
    }
    'standalone': {
      include puppet::master::standalone
    }
  }

}
