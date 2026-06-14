# Define: portage::postsync
#
# @summary
#   Installs a custom Portage postsync script.
#
# @example Install with inline content
#   portage::postsync { 'system-bell':
#     ensure  => present,
#     content => "#!/bin/sh\necho -e \"\\a\"",
#   }
#
# @example Install from a source file
#   portage::postsync { 'update-eix':
#     ensure => present,
#     source => 'puppet:///modules/portage/postsync/update-eix.sh',
#   }
#
# @param ensure
#   Ensure value for `/etc/portage/postsync.d/${name}`.
#
# @param content
#   Script content. Mutually exclusive with `$source`; exactly one required.
#
# @param source
#   Script source path. Mutually exclusive with `$content`; exactly one required.
#
# @see http://www.gentoo.org/doc/en/portage-utils.xml portage-utils
#
define portage::postsync (
  Enum['present', 'absent'] $ensure = 'present',
  Optional[String] $content = undef,
  Optional[String] $source = undef,
) {
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
