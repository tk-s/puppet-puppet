class puppet::master (
  $settings,
  $master_package = $::puppet::params::master_package,
  $package_ensure = $::puppet::params::package_ensure,
  $config_file    = $::puppet::params::config_file,
) inherits puppet::params {

  $settings['master'].each { |$setting, $value|
    ini_setting { "master/${setting}":
      ensure  => present,
      path    => $config_file,
      section => 'master',
      setting => $setting,
      value   => $value,
      tag     => 'puppet-config',
      require => Package['puppet'],
    }
  }

  package { 'puppet-master':
    name    => $master_package,
    ensure  => $package_ensure,
    require => Package['rake'],
  }

}
