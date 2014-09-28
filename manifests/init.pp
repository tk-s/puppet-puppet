class puppet (
  $settings,
  $package_name   = $::puppet::params::package_name,
  $package_ensure = $::puppet::params::package_ensure,
  $config_file    = $::puppet::params::config_file,
) inherits puppet::params {

  package { 'puppet':
    name   => $package_name,
    ensure => $package_ensure,
  }

  if $puppet::params::package_common {
    package { 'puppet-common':
      name   => $puppet::params::package_common,
      ensure => $package_ensure,
      before => Package['puppet'],
    }
  }

  $settings.each |$setting, $value| {
    ini_setting { "${config_file} main/${setting}":
      ensure  => present,
      path    => $config_file,
      section => 'main',
      setting => $setting,
      value   => $value,
      tag     => 'puppet-config',
      require => Package['puppet'],
    }
  }

}
