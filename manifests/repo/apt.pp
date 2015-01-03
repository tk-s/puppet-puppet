# == Class: puppet::repo::apt
#
# Installs the Puppet apt repo
#
class puppet::repo::apt {
  apt::source { 'puppetlabs':
    location   => 'http://apt.puppetlabs.com',
    repos      => 'main dependencies',
    key        => '4BD6EC30',
    key_server => 'pgp.mit.edu',
  }
}
