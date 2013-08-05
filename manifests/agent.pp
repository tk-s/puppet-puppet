class puppet::agent (
  $settings,
  $agent_package  = $::puppet::params::agent_package,
  $package_ensure = $::puppet::params::package_ensure,
  $config_file    = $::puppet::params::config_file,
  $service        = 'daemon'
) inherits puppet::params {

  package { 'puppet':
    name   => $agent_package,
    ensure => $agent_package_ensure,
  }

  if (has_key($settings, 'agent')) {
    $settings['agent'].each { |$setting, $value|
      ini_setting { "agent/${setting}":
        ensure  => present,
        path    => $config_file,
        section => 'agent',
        setting => $setting,
        value   => $value,
        tag     => 'puppet-config',
        require => Package['puppet'],
      }
    }
  } else {
    fail('Must pass $settings with an "agent" hash of key => value settings')
  }

  if ($service == 'daemon') {
    Ini_setting <| tag =='puppet-agent' |> ~> Service['puppet']

    service { 'puppet':
      ensure  => running,
      enable  => true,
      require => Package['puppet'],
    }

    case $::lsbdistid {
      'Ubuntu': {
        file_line { '/etc/default/puppet START':
          path    => '/etc/default/puppet',
          line    => 'START=yes',
          match   => '^START=',
          require => Package['puppet'],
        }
      }
    }
  }

}
