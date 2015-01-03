# == Class: puppet::config
#
# Configures Puppet
#
class puppet::config {

  # puppet.conf [main] settings
  $::puppet::main_settings.each |$setting, $value| {
    ini_setting { "${::puppet::config_file} main/${setting}":
      ensure  => present,
      path    => $::puppet::config_file,
      section => 'main',
      setting => $setting,
      value   => $value,
      tag     => 'puppet-config',
      require => Package['puppet'],
    }
  }

  if $::puppet::agent {
    # puppet.conf [agent] settings
    $::puppet::agent_settings.each |$setting, $value| {
      ini_setting { "${::puppet::config_file} agent/${setting}":
        ensure  => present,
        path    => $::puppet::config_file,
        section => 'agent',
        setting => $setting,
        value   => $value,
        tag     => 'puppet-config',
        require => Package['puppet'],
      }
    }

    if $::puppet::agent_service_mode == 'daemon' {
      if $::lsbdistid == 'Ubuntu' {
        file_line { '/etc/default/puppet START':
          path    => '/etc/default/puppet',
          line    => 'START=yes',
          match   => '^START=',
          require => Package['puppet'],
        }
      }
    }

  }

  if $::puppet::server {
    # puppet.conf [master] settings
    $::puppet::master_settings.each |$setting, $value| {
      ini_setting { "${::puppet::config_file} master/${setting}":
        ensure  => present,
        path    => $::puppet::config_file,
        section => 'master',
        setting => $setting,
        value   => $value,
        tag     => 'puppet-config',
        require => Package['puppet'],
      }
    }

    # /etc/default/puppetserver settings
    if $::lsbdistid == 'Ubuntu' {
      $::puppet::server_default_settings.each |$setting, $value| {
        file_line { "${::puppet::server_default_file} ${setting} ${value}":
          path    => $::puppet::server_default_file,
          line    => "${setting}=\"${value}\"",
          match   => "^${setting}=",
          require => Package['puppetserver'],
        }
      }
    }

    if has_key($::puppet::master_settings, 'reportdir') {
      file { $::puppet::master_settings['reportdir']:
        ensure  => directory,
        recurse => true,
        owner   => 'puppet',
        group   => 'puppet',
        mode    => '0640',
      }
    }
  }

}
