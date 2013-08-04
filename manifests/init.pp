class puppet (
  $settings,
  $agent_package         = $::puppet::params::agent_package,
  $master_package        = $::puppet::params::master_package,
  $agent_package_ensure  = $::puppet::params::package_ensure,
  $master_package_ensure = $::puppet::params::package_ensure,
  $config_file           = $::puppet::params::config_file,
  $agent                 = false,
  $agent_service         = 'daemon',
  $master                = false,
  $master_type           = false
) inherits puppet::params {

  $settings['main'].each { |$setting, $value|
    ini_setting { "main/${setting}":
      ensure  => present,
      path    => $config_file,
      section => 'main',
      setting => $setting,
      value   => $value,
      tag     => 'puppet-config',
      require => Package['puppet'],
    }
  }

  if ($agent) {
    class { 'puppet::agent':
      settings       => $settings,
      agent_package  => $agent_package,
      package_ensure => $agent_package_ensure,
      config_file    => $config_file,
      service        => $agent_service,
    }
  }

  if ($master) {
    class { 'puppet::master':
      settings       => $settings,
      master_package => $master_package,
      package_ensure => $master_package_ensure,
      config_file    => $config_file
    }

    case $master_type {
      'nginx': {
        class { 'puppet::master::nginx':
          settings => $settings,
          require  => [Class['puppet::master'], Package['rake']],
        }
      }
    }
  }
}
