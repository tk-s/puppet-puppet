class puppet::master (
  $settings,
  $master_package = $::puppet::params::master_package,
  $package_ensure = $::puppet::params::package_ensure,
  $config_file    = $::puppet::params::config_file,
) inherits puppet::params {

  if (has_key($settings, 'master')) {
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
  } else {
    fail('Must pass $settings with a "master" hash of key => value settings.')
  }

  if (has_key($settings['master'], 'reportdir')) {
    file { $settings['master']['reportdir']:
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

}
