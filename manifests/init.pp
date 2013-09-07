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

  if (has_key($settings, 'main')) {
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
  } else {
    fail('Must pass $settings with a "main" hash of key => value settings.')
  }

}
