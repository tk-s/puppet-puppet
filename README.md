# puppet-puppet

Installs and configures Puppet agent and Puppet-server

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
puppet::server::puppet_conf_settings:
  ca: true
  ssldir: '/var/lib/puppet/ssl'
# /etc/default/puppetserver settings
puppet::server::default_settings:
  JAVA_ARGS: '-Xms1g -Xmx1g -XX:MaxPermSize=256m'

```

Then to configure a server as a Puppet Master, create a class like this:

```puppet
class site::roles::puppet_server {
  include ::puppet
  include ::puppet::server
  include ::puppetdb
  include ::puppetdb::master::config
}
```
