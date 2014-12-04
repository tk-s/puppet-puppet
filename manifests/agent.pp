class puppet::agent (
  $settings,
  $config_file = $::puppet::params::config_file,
  $service     = 'daemon'
) inherits puppet::params {

  $settings.each { |$setting, $value|
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

  if ($service == 'daemon') {
    Ini_setting <| tag =='puppet-agent' |> ~> Service['puppet']

    service { 'puppet':
      ensure  => running,
      enable  => true,
      require => Package['puppet'],
    }

    case $::lsbdistid {
      'Ubuntu': {
        file { '/etc/default/puppet':
          ensure => present,
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
        }

        file_line { '/etc/default/puppet START':
          path    => '/etc/default/puppet',
          line    => 'START=yes',
          match   => '^START=',
          require => [Package['puppet'], File['/etc/default/puppet']],
        }
      }
    }
  }

}
