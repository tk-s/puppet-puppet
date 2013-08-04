class puppet::agent {

  Ini_setting <| tag =='puppet-agent' |> ~> Service['puppet']

  Ini_setting {
    ensure  => present,
    section => 'agent',
    path    => hiera('puppet_conf'),
    require => Package['puppet'],
    tag     => 'puppet-agent',
  }

  package { 'puppet':
    name   => hiera('puppet_agent_package'),
    ensure => hiera('puppet_package_ensure'),
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

  ini_setting {
    'agent/certname':
      setting => 'certname',
      value   => $::clientcert;
  }

  service { 'puppet':
    ensure  => running,
    enable  => true,
    require => [package['puppet'], ini_setting['agent/certname']],
  }

}
