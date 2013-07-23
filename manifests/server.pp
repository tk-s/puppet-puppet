class puppet::server {

  include puppet::server::nginx

  package { 'puppet-server':
    name    => hiera('puppet_server_package'),
    ensure  => hiera('puppet_package_ensure'),
    require => Package['rake'],
  }

  Ini_setting {
    ensure  => present,
    path    => hiera('puppet_conf'),
    section => 'master',
    require => Package['puppet-server'],
  }

  ini_setting {
    'master/modulepath':
      setting => 'modulepath',
      value   => hiera('puppet_modulepath');
  }

}
