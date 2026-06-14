# Class: portage
#
# @summary
#   Configure the Portage package management system
#
#
# @param manage_make_conf
#   Whether this class should manage `/etc/portage/make.conf` as a `concat`
#   resource. Additional fragments can be added separately via `portage::makeconf`.
#
# @param make_conf_remerge
#   Whether changes to `$make_conf` should trigger a re-emerge of all
#   packages with changed USE flags. Only has an effect when
#   `$manage_make_conf` is `true`.
#
# @param make_conf
#   Absolute path to the Portage make.conf file to manage (typically
#   `/etc/portage/make.conf`).
#
# @param emerge_command
#   Absolute path to the `emerge` command.
#
#
# @see emerge(1) http://dev.gentoo.org/~zmedico/portage/doc/man/emerge.1.html
# @see make.conf(5) http://dev.gentoo.org/~zmedico/portage/doc/man/make.conf.5.html
#
class portage (
  Boolean $manage_make_conf,
  Boolean $make_conf_remerge,
  Stdlib::Unixpath $make_conf,
  Stdlib::Unixpath $emerge_command,
) {
  include portage::install

  file { [
      '/etc/portage/package.accept_keywords',
      '/etc/portage/package.mask',
      '/etc/portage/package.unmask',
      '/etc/portage/package.use',
      '/etc/portage/postsync.d',
    ]:
      ensure => directory;
  }

  if $manage_make_conf {
    concat { $make_conf:
      owner => 'root',
      group => 'root',
      mode  => '0644',
    }

    concat::fragment { 'makeconf_header':
      target  => $make_conf,
      content => template('portage/makeconf.header.conf.erb'),
      order   => '00',
    }

    exec { 'changed_makeconf':
      command     => "${emerge_command} -1 --changed-use $(qlist -vIC | sed \'s/^/=/\')",
      refreshonly => true,
      timeout     => 43200,
      provider    => shell,
      path        => [
        '/usr/local/sbin','/usr/local/bin',
        '/usr/sbin','/usr/bin','/sbin','/bin',
      ],
    }

    if ($make_conf_remerge) {
      Concat[$make_conf] ~> Exec['changed_makeconf']
    }
  }
}
