class puppet::master::passenger {

  Ini_setting<| tag == 'puppet-config' |> ~> Apache::Vhost['puppet-master']

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
    notify  => Apache::Vhost['puppet-master'],
  }

  # Configure rack
  file { ['/etc/puppet/rack', '/etc/puppet/rack/public', '/etc/puppet/rack/tmp']:
    owner => 'puppet',
    group => 'puppet',
    ensure => directory,
  }

  file { '/etc/puppet/rack/config.ru':
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0644',
    source => 'puppet:///modules/puppet/config.ru',
  }

  # Create Apache vhost
  $ssldir = $::puppet::settings['ssldir']
  apache::vhost { 'puppet-master':
    servername        => $::fqdn,
    ip                => '*',
    port              => '8140',
    priority          => '10',
    docroot           => '/etc/puppet/rack/public/',
    ssl               => true,
    ssl_cipher        => 'ALL:!ADH:!EXP:!LOW:+RC4:+HIGH:+MEDIUM:!SSLv2:+SSLv3:+TLSv1:+eNULL',
    ssl_cert          => "${ssldir}/certs/${::fqdn}.pem",
    ssl_key           => "${ssldir}/private_keys/${::fqdn}.pem",
    ssl_chain         => "${ssldir}/certs/ca.pem",
    ssl_ca            => "${ssldir}/ca/ca_crt.pem",
    ssl_crl           => "${ssldir}/ca/ca_crl.pem",
    ssl_verify_client => 'optional',
    ssl_verify_depth  => '1',
    ssl_options       => ['+StdEnvVars', '+ExportCertData'],
    request_headers   => [
      'set X-SSL-Subject %{SSL_CLIENT_S_DN}e',
      'set X-Client-DN %{SSL_CLIENT_S_DN}e',
      'set X-Client-Verify %{SSL_CLIENT_VERIFY}e',
    ],
  }

}
