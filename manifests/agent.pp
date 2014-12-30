class puppet::agent (
  $settings,
  $service        = 'daemon',
  $service_enable = true,
  $service_ensure = 'running',
) {

  include puppet::params

  $settings.each |$setting, $value| {
    ini_setting { "${::puppet::params::config_file} agent/${setting}":
      ensure  => present,
      path    => $::puppet::params::config_file,
      section => 'agent',
      setting => $setting,
      value   => $value,
      tag     => 'puppet-config',
      require => Package['puppet'],
    }
  }

  if $service == 'daemon' {

    Ini_setting <| tag =='puppet-config' |> ~> Service['puppet']

    service { 'puppet':
      ensure  => $service_ensure,
      enable  => $service_enable,
      require => Package['puppet'],
    }

    if $::lsbdistid == 'Ubuntu' {
      file_line { '/etc/default/puppet START':
        path    => '/etc/default/puppet',
        line    => 'START=yes',
        match   => '^START=',
        require => Package['puppet'],
      }
    }

  }

}
