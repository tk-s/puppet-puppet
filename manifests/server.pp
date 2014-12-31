# TODO: Add new /etc/puppetserver settings
class puppet::server (
  $puppet_conf_settings = {},
  $default_settings     = {},
  $package_ensure       = 'latest',
  $service_ensure       = 'running',
  $service_enable       = true,
) {

  include puppet::params

  $puppet_conf_settings.each |$setting, $value| {
    ini_setting { "${::puppet::params::config_file} master/${setting}":
      ensure  => present,
      path    => $::puppet::params::config_file,
      section => 'master',
      setting => $setting,
      value   => $value,
      tag     => 'puppet-config',
      require => Package['puppet'],
    }
  }

  package { 'puppetserver':
    name    => $::puppet::params::server_package,
    ensure  => $package_ensure,
  }

  $default_settings.each |$setting, $value| {
    file_line { "$::puppet::params::default_file ${setting} ${value}":
      path    => $::puppet::params::default_file,
      line    => "${setting}=\"${value}\"",
      match   => "^${setting}=",
      require => Package['puppetserver'],
    }
  }

  if has_key($puppet_conf_settings, 'reportdir') {
    file { $puppet_conf_settings['reportdir']:
      ensure  => directory,
      recurse => true,
      owner   => 'puppet',
      group   => 'puppet',
      mode    => '0640',
    }
  }

  server { 'puppetserver':
    ensure => $service_ensure,
    enable => $service_enable,
    name   => $::puppet::params::server_service,
  }

}
