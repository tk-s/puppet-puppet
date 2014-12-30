class puppet (
  $settings,
  $package_ensure = 'latest',
) {

  include puppet::params

  package { 'puppet':
    ensure => $package_ensure,
    name   => $::puppet::params::package_name,
  }

  if $puppet::params::package_common {
    package { 'puppet-common':
      name   => $puppet::params::package_common,
      ensure => $package_ensure,
      before => Package['puppet'],
    }
  }

  $settings.each |$setting, $value| {
    ini_setting { "${::puppet::params::config_file} main/${setting}":
      ensure  => present,
      path    => $::puppet::params::config_file,
      section => 'main',
      setting => $setting,
      value   => $value,
      tag     => 'puppet-config',
      require => Package['puppet'],
    }
  }

}
