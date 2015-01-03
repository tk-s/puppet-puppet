# puppet-puppet

Installs and configures Puppet agent and Puppet-server

## Usage

This module takes advantage of the new iteration features of Puppet 3.2, so you will need to add the following to `puppet.conf`:

```puppet
parser = future
```

To begin, place something similar to the following in Hiera:

```yaml
site::puppet::puppet_package_ensure: 'latest'
site::puppet::server_package_ensure: 'latest'
site::puppet::settings::main:
  server: 'puppet'
  parser: 'future'
  ordering: 'manifest'
  pluginsync: true
  logdir: '/var/log/puppet'
  vardir: '/var/lib/puppet'
  ssldir: '/var/lib/puppet/ssl'
  rundir: '/var/run/puppet'
site::puppet::settings::agent:
  certname: "%{::fqdn}"
  show_diff: true
  splay: false
  configtimeout: 360
  usecacheonfailure: true
  report: true
  environment: "%{::environment}"
site::puppet::settings::server_default:
  JAVA_ARGS: '-Xms1g -Xmx1g -XX:MaxPermSize=256m'
site::puppet::settings::master:
  ca: true
  ssldir: '/var/lib/puppet/ssl'
puppetdb::master::config::restart_puppet: false
```

Next, create a profile for the Puppet server:

```puppet
class site::profiles::puppet::server {

  # Hiera
  $main_settings           = hiera('site::puppet::settings::main')
  $agent_settings          = hiera('site::puppet::settings::agent')
  $master_settings         = hiera('site::puppet::settings::master')
  $server_default_settings = hiera('site::puppet::settings::server_default')
  $puppet_package_ensure   = hiera('site::puppet::puppet_package_ensure')
  $server_package_ensure   = hiera('site::puppet::server_package_ensure')

  # Resources
  class { '::puppet':
    server                  => true,
    main_settings           => $main_settings,
    agent_settings          => $agent_settings,
    master_settings         => $master_settings,
    server_default_settings => $server_default_settings,
    puppet_package_ensure   => $server_package_ensure,
  }

  class { 'puppetdb': }
  class { 'puppetdb::master::config':
    restart_puppet => false,
  }

}
```

Then create a profile for the agents:

```puppet
class site::profiles::puppet::agent {

  # Hiera
  $main_settings           = hiera('site::puppet::settings::main')
  $agent_settings          = hiera('site::puppet::settings::agent')
  $puppet_package_ensure   = hiera('site::puppet::puppet_package_ensure')

  # Resources
  class { '::puppet':
    main_settings         => $main_settings,
    agent_settings        => $agent_settings,
    puppet_package_ensure => $server_package_ensure,
  }

}
```

Finally, apply either the `server` profile or `agent` profile to the roles that require them.
