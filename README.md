# puppet-puppet

This is a small puppet module to configure Puppet. It is roughly based on the [puppetlabs-operations](http://github.com/puppetlabs-operations/puppet-puppet) module.

To configure the Puppet Master with Nginx, you'll need the following modules:

* [jtopjian/nginx](https://github.com/jtopjian/puppet-nginx)
* [jtopjian/unicorn](https://github.com/jtopjian/puppet-unicorn)

Or to configure the Puppet Master to be hosted through Passenger, you'll need the [puppetlabs/apache](https://github.com/puppetlabs/puppetlabs-apache) module.

## Usage

This module takes advantage of the new iteration features of Puppet 3.2, so you will need to add the following to `puppet.conf`:

```puppet
parser = future
```

The three main classes, `init`, `agent`, and `master` require a `settings` parameter. This parameter is a nested key/value hash of settings that go in `puppet.conf`. For example:

```yaml
# puppet.confg [main] settings
puppet::settings:
  logdir: '/var/log/puppet'
  vardir: '/var/lib/puppet'
  ssldir: '/var/lib/puppet/ssl'
  rundir: '/var/run/puppet'
  parser: 'future'
  evaluator: 'current'
  ordering: 'manifest'
  environmentpath: '$confdir/environments'
  server: 'puppet.z.terrarum.net'
  ca_server: 'puppet.z.terrarum.net'
  report_server: 'puppet.z.terrarum.net'
  pluginsync: true
# puppet.conf [agent] settings
puppet::agent::settings:
  certname: "%{::fqdn}"
  show_diff: true
  splay: false
  configtimeout: 360
  usecacheonfailure: true
  report: true
  environment: "%{::environment}"
# puppet.conf [master] settings
puppet::master::settings:
  ca: true
# puppet master configuration
puppet::master::servertype: 'passenger'
```

Then to configure a server as a Puppet Master, create a class like this:

```puppet
class site::roles::puppet::master {
  include ::apache
  include ::apache::mod::ssl
  include ::apache::mod::passenger
  include ::puppet
  include ::puppet::master
  include ::puppetdb
  include ::puppetdb::master::config
}
```
