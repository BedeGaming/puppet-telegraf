# == Class: telegraf::config
#
# Templated generation of telegraf.conf
#
class telegraf::config inherits telegraf {

  assert_private()

  file {
    $::telegraf::config_file:
      ensure  => file,
      content => template('telegraf/telegraf.conf.erb'),
      owner   => $::telegraf::config_file_owner,
      group   => $::telegraf::config_file_group,
      mode    => '0775',
      notify  => Class['::telegraf::service'],
      require => Class['::telegraf::install'],
    ;
    $::telegraf::config_folder:
      ensure  => directory,
      owner   => $::telegraf::config_file_owner,
      group   => $::telegraf::config_file_group,
      mode    => '0775',
      purge   => $::telegraf::purge_config_fragments,
      recurse => true,
      notify  => Class['::telegraf::service'],
      require => Class['::telegraf::install'],
    ;
  }->

  concat { "${telegraf::config_folder}/telegraf.conf":
    mode => '0777'
  }~>

  Class['::telegraf::service']
}
