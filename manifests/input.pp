# == Define: telegraf::input
#
# A Puppet wrapper for discrete Telegraf input files
#
# === Parameters
#
# [*options*]
#   Hash. Plugin options for use the the input template.
#
# [*single_section*]
#   Hash. Some inputs take a single unique section in [single brackets].
#
# [*sections*]
#   Hash. Some inputs take multiple sections in [[double brackets]].

define telegraf::input (
  $plugin_type    = $name,
  $options        = undef,
  $single_section = undef,
  $sections       = undef,
) {
  include telegraf

  if $options {
    validate_hash($options)
  }

  if $single_section {
    validate_hash($single_section)
  }

  if $sections {
    validate_hash($sections)
  }

  concat::fragment{ "telegraf_input_$name":
    target  => "${telegraf::config_folder}/telegraf.conf",
    content => template('telegraf/input.conf.erb'),
    order   => '10',
  }
}
