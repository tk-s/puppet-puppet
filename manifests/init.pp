# == Class: puppet
#
# Installs and configures Puppet including the Agent and Server.
#
# === Parameters:
#
# [*manage_repo*]
#   Whether or not to configure a repo with newer packages.
#
# [*puppet_package_name*]
#   The name of the `puppet` package.
#
# [*puppet_package_ensure*]
#   The ensure status of the `puppet` package.
#
# [*main_settings*]
#   A hash of k/v settings for `[main]` in `puppet.conf`.
#
# [*agent*]
#   Whether or not to configure an agent.
#
# [*agent_service_name*]
#   The name of the agent service.
#
# [*agent_service_mode*]
#   Whether to daemonize the agent service.
#
# [*agent_service_enable*]
#   The enable status of the agent service.
#
# [*agent_service_ensure*]
#   The ensure status of the agenet service.
#
# [*agent_settings*]
#   A hash of k/v settings for the `[agent]` in `puppet.conf`.
#
# [*server*]
#   Whether or not to install and configure puppet server.
#
# [*server_package_name*]
#   The package name of puppet server.
#
# [*server_package_ensure*]
#   The ensure status of the puppet server package.
#
# [*server_service_name*]
#   The name of the puppet server service.
#
# [*server_default_file*]
#   The name of `/etc/default/puppetserver` for Debian/Ubuntu systems.
#
# [*server_default_settings*]
#   Settings that go in $server_default_file.
#
# [*server_service_ensure*]
#   The ensure status of the puppet server service.
#
# [*server_service_enable*]
#   The enable status of the puppet server service.
#
# [*master_settings*]
#   A hash of k/v settings for the `[master]` in `puppet.conf`.
#
class puppet (
  $manage_repo             = $puppet::params::manage_repo,
  $puppet_package_name     = $puppet::params::package_name,
  $puppet_package_ensure   = $puppet::params::puppet_package_ensure,
  $main_settings           = $puppet::params::main_settings,
  $agent                   = $puppet::params::agent,
  $agent_service_name      = $puppet::params::agent_service_name,
  $agent_service_mode      = $puppet::params::agent_service_mode,
  $agent_service_ensure    = $puppet::params::agent_service_ensure,
  $agent_service_enable    = $puppet::params::agent_service_enable,
  $agent_settings          = $puppet::params::agent_settings,
  $server                  = $puppet::params::server,
  $server_package_name     = $puppet::params::server_package,
  $server_package_ensure   = $puppet::params::server_package_ensure,
  $server_service_name     = $puppet::params::server_service_name,
  $server_default_file     = $puppet::params::server_default_file,
  $server_default_settings = $puppet::params::server_default_settings,
  $server_service_ensure   = $puppet::params::server_service_ensure,
  $server_service_enable   = $puppet::params::server_service_enable,
  $master_settings         = $puppet::params::master_settings,
) inherits puppet::params {

  anchor { 'puppet::begin': } ->
  class { 'puppet::repo': } ->
  class { 'puppet::install': } ->
  class { 'puppet::config': } ->
  class { 'puppet::service': } ->
  anchor { 'puppet::end': }

  Class['puppet::config'] ~> Class['puppet::service']

}
