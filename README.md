# puppet-puppet

This is a small puppet module to configure Puppet. It is roughly based on the [puppetlabs-operations](http://github.com/puppetlabs-operations/puppet-puppet) module.

It is *very* site-specific and is not really mean for widespread use.

It also requires some of my other modules:

* [nginx](https://github.com/jtopjian/puppet-nginx)
* [unicorn](https://github.com/jtopjian/puppet-unicorn)

## Usage

This module takes advantage of the new iteration features of Puppet 3.2, so you will need to add the following to `puppet.conf`:

```puppet
parser = future
```

Next, the `init` manifest takes a parameter called `$settings`. `$settings` is a nested hash with the following sub-hashes: `main`, `agent`, `master`. These sub-hashes correspond to the various sections of `puppet.conf`. An example `$settings` hash looks like:

```puppet
$puppet_config = {
  'main'        => {
    confdir     => '/etc/puppet',
    logdir      => '/var/log/puppet',
    vardir      => '/var/lib/puppet',
    ssldir      => '/var/lib/puppet/ssl',
    rundir      => '/var/run/puppet',
    templatedir => '/etc/puppet/templates',
    modulepath  => '/etc/puppet/site/modules:/etc/puppet/modules',
    parser      => 'future',
  },
  'agent'  => {
    certname => $::clientcert,
  },
  'master' => {
    ssl_client_header        => 'HTTP_X_CLIENT_DN',
    ssl_client_verify_header => 'HTTP_X_CLIENT_VERIFY',
    reportdir                => '/var/lib/puppet/reports',
  }
}
```
