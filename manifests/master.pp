class puppet::master (
  $settings,
  $master_package = $::puppet::params::puppet_master_package,
  $package_ensure = $::puppet::params::puppet_package_ensure,
  $config_file    = $::puppet::params::config_file,
) inherits puppet::params {

  $settings.each { |$setting, $value|
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

  if (has_key($settings, 'reportdir')) {
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
    require => Package['rake'],
  }

  if $::puppet::params::puppet_master_common_package {
    package { 'puppet-master-common':
      name   => $::puppet::params::puppet_master_common_package,
      ensure => $package_ensure,
    }
  }

}
