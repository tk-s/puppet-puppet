class puppet::general {

  Ini_setting {
    ensure  => present,
    section => 'main',
    path    => hiera('puppet_conf'),
    require => Package['puppet'],
  }

  ini_setting {
    'main/server':
      setting => 'server',
      value   => hiera('puppet_server');
    'main/pluginsync':
      setting => 'pluginsync',
      value   => true;
    'main/logdir':
      setting => 'logdir',
      value   => hiera('puppet_logdir');
    'main/vardir':
      setting => 'vardir',
      value   => hiera('puppet_vardir');
    'main/ssldir':
      setting => 'ssldir',
      value   => hiera('puppet_ssldir');
    'main/rundir':
      setting => 'rundir',
      value   => hiera('puppet_rundir');
  }

  case $::lsbdistid {
    'Ubuntu': {
      ini_setting {
        'main/precommand_run':
          setting => 'precommand_run',
          value   => '/etc/puppet/etckeeper-commit-pre';
        'main/postcommand_run':
          setting => 'postcommand_run',
          value   => '/etc/puppet/etckeeper-commit-post';
      }
    }
  }
}
