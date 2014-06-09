class puppet::master::nginx (
  $settings,
) inherits puppet::params {

  Ini_setting<| tag == 'puppet-config' |> ~> Unicorn::App['puppet-master']

  # Disable the puppetmaster service from starting
  case $::lsbdistid {
    'Ubuntu': {
      file_line { '/etc/default/puppetmaster START':
        path    => '/etc/default/puppetmaster',
        line    => 'START=no',
        match   => '^START=',
        require => Package['puppet-master'],
      }
    }
  }

  service { 'puppet-master':
    name    => $::puppet::master::master_service,
    ensure  => 'stopped',
    enable  => false,
    require => Package['puppet-master'],
    notify  => [Unicorn::App['puppet-master'], Nginx::Vhost['puppet-master']],
  }

  # Create an Nginx vhost
  $ssldir = $settings['ssldir']
  nginx::vhost { 'puppet-master':
    port     => 8140,
    template => 'puppet/nginx/unicorn.conf.erb',
  }

  # Create a unicorn app
  $confdir = $settings['confdir']
  $rundir  = $settings['rundir']
  $logdir  = $settings['logdir']
  unicorn::app { 'puppet-master':
    approot     => $confdir,
    config_file => "${confdir}/unicorn.conf",
    pidfile     => "${rundir}/puppetmaster_unicorn.pid",
    socket      => "${rundir}/puppetmaster_unicorn.sock",
    logdir      => $logdir,
    user        => 'puppet',
    group       => 'puppet',
    require     => Nginx::Vhost['puppet-master'],
    notify      => Exec['kick unicorn'],
  }

  # Configure Rack
  file { "${confdir}/config.ru":
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0644',
    source => 'puppet:///modules/puppet/config.ru',
    notify => Nginx::Vhost['puppet-master'],
  }

  # dirty hack to kick unicorn post-install
  exec { 'kick unicorn':
    command     => '/etc/init.d/unicorn_puppet-master restart',
    refreshonly => true,
    require     => Unicorn::App['puppet-master'],
  }

}
