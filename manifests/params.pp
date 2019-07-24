class profile::telegraf (
){
  contain '::telegraf'

  $inputs = hiera_hash('profile::telegraf::inputs',{})
  create_resources(telegraf::input, $inputs)

  $redis_inputs = hiera('profile::telegraf::redis::inputs',{})
  $redis_inputs_defaults = hiera('profile::telegraf::redis::inputs::defaults',{})
  create_resources(telegraf::input, $redis_inputs,$redis_inputs_defaults)

  $outputs = hiera_hash('profile::telegraf::outputs',{})
  create_resources(telegraf::output, $outputs)

  $consul_services = hiera_hash('profile::telegraf::consul_services', {})
  $consul_checks = hiera_hash('profile::telegraf::consul_checks', {})

  case $::kernel {
    'Linux':   {
      create_resources('::consul::service', $consul_services)
      create_resources('::consul::check', $consul_checks)
      user { "telegraf":
        groups => ["puppet","root"],
        notify => Class['telegraf::service'],
      }
    }
    'windows': {
      create_resources('::winconsul::service', $consul_services)
      create_resources('::winconsul::check', $consul_checks)
    }
    default:   { fail("Unknown kernel ${::kernel}") }
  }


}
