class puppet::agent (
  $settings,
  $config_file    = $::puppet::params::config_file,
  $service        = 'daemon',
  $service_enable = true,
) inherits puppet::params {

  $settings.each |$setting, $value| {
    ini_setting { "${config_file} agent/${setting}":
      ensure  => present,
      path    => $config_file,
      section => 'agent',
      setting => $setting,
      value   => $value,
      tag     => 'puppet-config',
      require => Package['puppet'],
    }
  }

  if $service == 'daemon' {

    Ini_setting <| tag =='puppet-config' |> ~> Service['puppet']

    if $service_enable == true {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'puppet':
      ensure  => $service_ensure,
      enable  => $service_enable,
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
