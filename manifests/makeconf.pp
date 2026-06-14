# Define: portage::makeconf
#
# @summary
#   Manages a fragment of Gentoo's make.conf via concat.
#
# @example manage MAKEOPTS
#   portage::makeconf { 'makeopts':
#     ensure  => present,
#     content => '-j8',
#     order   => '10',
#   }
#
# @param ensure
#   Whether the fragment is `present` or `absent`.
#
# @param content
#   Content rendered into the fragment via `portage/makeconf.conf.erb`.
#
# @param order
#   Ordering value passed to `concat::fragment`.
#
define portage::makeconf (
  Enum['present', 'absent'] $ensure = present,
  Optional[String] $content = undef,
  Optional[Variant[String, Integer]] $order = undef,
) {
  include portage

  if($portage::manage_make_conf and $ensure == 'present') {
    concat::fragment { $name:
      content => template('portage/makeconf.conf.erb'),
      target  => $portage::make_conf,
      order   => $order,
    }
  }
}
