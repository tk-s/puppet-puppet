class puppet::master::nginx(
  $settings
) inherits puppet::params {

  Ini_setting<| tag == 'puppet-config' |> ~> Unicorn::App['puppet-master']

  # Disable the puppetmaster service from starting
  case $::lsbdistid {
    'Ubuntu': {
      file_line { '/etc/default/puppetmaster START':
        path    => '/etc/default/puppetmaster',
        line    => 'START=no',
        match   => '^START=',
        notify  => Exec['kill puppetmaster'],
        require => Package['puppet-master'],
      }
    }
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
    approot         => $confdir,
    config_file     => "${confdir}/unicorn.conf",
    pidfile         => "${rundir}/puppetmaster_unicorn.pid",
    socket          => "${rundir}/puppetmaster_unicorn.sock",
    logdir          => $logdir,
    user            => 'puppet',
    group           => 'puppet',
    require         => Nginx::Vhost['puppet-master'],
  }

  # Configure Rack
  file { "${confdir}/config.ru":
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0644',
    source => 'puppet:///modules/puppet/config.ru',
    notify => Nginx::Vhost['puppet-master'],
  }

  # Dirty hack because apt starts the puppet master by default
  exec { 'kill puppetmaster':
    command     => '/etc/init.d/puppetmaster stop',
    refreshonly => true,
    notify      => Exec['kick unicorn'],
  }

  # Another dirty hack to kick unicorn post-install
  exec { 'kick unicorn':
    command     => '/etc/init.d/unicorn_puppet-master restart',
    refreshonly => true,
  }

}
