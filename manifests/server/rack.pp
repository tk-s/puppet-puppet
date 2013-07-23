class puppet::server::rack {

  $confdir = hiera('puppet_confdir')
  concat { "${confdir}/config.ru":
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0644',
    notify => Nginx::Vhost['puppet-server'],
  }

  concat::fragment { "run-puppet-master":
    order  => '99',
    target => "${confdir}/config.ru",
    source => 'puppet:///modules/puppet/config.ru',
  }
}
