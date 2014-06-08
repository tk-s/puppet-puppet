class puppet::master::standalone (
  $config_file    = $::puppet::params::config_file,
  $master_service = $::puppet::params::master_service,
  $service_enable = true,
) inherits puppet::params {

  Ini_setting <| tag =='puppet-config' |> ~> Service['puppet-master']

  if $service_enable == true {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'puppet-master':
    name    => $master_service,
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => Package['puppet-master'],
  }

}
