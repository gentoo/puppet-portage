# = Define: portage::makeconf
#
# Adds sections to make.conf
#
# == Parameters
#
# [*name*]
#
# The name of the make.conf variable
#
# [*content*]
#
# The content of the configuration fragment. Must be of the form used
# by concat::fragment.
#
# [*ensure*]
#
# The ensure state of the makeconf section.
#
# == Example
#
#     portage::makeconf { 'use':
#       ensure  => present,
#       content => '-X ldap ruby',
#     }

define portage::makeconf (
  $ensure = present,
  $content = undef,
  $order   = undef,
) {
  include portage

  if($ensure == 'present') {
    concat::fragment { $name:
      content => template('portage/makeconf.conf.erb'),
      target  => $portage::make_conf,
      order   => $order,
    }
  }
}
