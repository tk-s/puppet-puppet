class puppet::server::nginx {

  include puppet::server::rack

  Ini_setting {
    ensure  => present,
    path    => hiera('puppet_conf'),
    section => 'master',
    require => Package['puppet-server'],
  }

  ini_setting {
    'master/ssl_client_header':
      setting => 'ssl_client_header',
      value   => hiera('nginx_ssl_client_header');
    'master/ssl_client_verify_header':
      setting => 'ssl_client_verify_header',
      value   => hiera('nginx_ssl_client_verify_header');
  }

  case $::lsbdistid {
    'Ubuntu': {
      file_line { '/etc/default/puppetmaster START':
        path    => '/etc/default/puppetmaster',
        line    => 'START=no',
        match   => '^START=',
        notify  => Exec['kill puppetmaster'],
        require => Package['puppet-server'],
      }
    }
  }

  $ssldir = hiera('puppet_ssldir')
  nginx::vhost { 'puppet-server':
    port     => 8140,
    template => 'puppet/nginx/unicorn.conf.erb',
    require  => Class['puppet::server::rack'],
  }

  $confdir = hiera('puppet_confdir')
  $rundir  = hiera('puppet_rundir')
  $logdir  = hiera('puppet_logdir')
  unicorn::app { 'puppet-server':
    approot         => $confdir,
    config_file     => "${confdir}/unicorn.conf",
    pidfile         => "${rundir}/puppetmaster_unicorn.pid",
    socket          => "${rundir}/puppetmaster_unicorn.sock",
    logdir          => $logdir,
    user            => 'puppet',
    group           => 'puppet',
    require         => Nginx::Vhost['puppet-server'],
  }

  # Dirty hack because apt starts the puppet master by default
  exec { 'kill puppetmaster':
    command     => '/etc/init.d/puppetmaster stop',
    refreshonly => true,
  }

}
