# = Define: portage::postsync
#
# Install custom postsync scripts
#
# == Parameters
#
# [*ensure*]
#
# The ensure value for the scrypt
#
# [*content*]
#
# The content of the script.
#
# [*source*]
#
# The source path to the script
#
# == Example
#
#     portage::postsync { 'system-bell':
#       ensure  => present,
#       content => "#!/bin/sh\necho -e \"\\a\""
#     }
#
# == See Also
#
# * portage-utils: http://www.gentoo.org/doc/en/portage-utils.xml
define portage::postsync (
  $ensure  = 'present',
  $content = undef,
  $source  = undef,
) {
  include portage

  if ($content and $source) or (!$content and !$source) {
    fail('One (and only one) of [$content, $source] must be specified')
  }

  file { "/etc/portage/postsync.d/${name}":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
}
