# = Class: portage
#
# Configure the Portage package management system
#
# == Parameters
#
# [*make_conf*]
#
# The path to make.conf.
#
# As of 2012-09-09 new systems will use /etc/portage/make.conf, but on older
# systems this can be /etc/make.conf.
#
# == Example
#
#     class { 'portage':
#       $make_conf = '/etc/portage/make.conf',
#     }
#
# == See Also
#
#  * emerge(1) http://dev.gentoo.org/~zmedico/portage/doc/man/emerge.1.html
#  * make.conf(5) http://dev.gentoo.org/~zmedico/portage/doc/man/make.conf.5.html

class portage (
  Boolean $manage_make_conf       = true,
  $make_conf                      = $portage::params::make_conf,
  $make_conf_remerge              = $portage::params::make_conf_remerge,
  $portage_ensure                 = $portage::params::portage_ensure,
  $portage_keywords               = $portage::params::portage_keywords,
  $portage_keywords_version       = $portage::params::portage_keywords_version,
  $portage_use                    = $portage::params::portage_use,
  $eix_ensure                     = $portage::params::eix_ensure,
  $eix_keywords                   = $portage::params::eix_keywords,
  $eix_keywords_version           = $portage::params::eix_keywords_version,
  $eix_use                        = $portage::params::eix_use,
  $layman_ensure                  = $portage::params::layman_ensure,
  $layman_keywords                = $portage::params::layman_keywords,
  $layman_keywords_version        = $portage::params::layman_keywords_version,
  $layman_use                     = $portage::params::layman_use,
  $layman_make_conf               = $portage::params::layman_make_conf,
  $webapp_config_ensure           = $portage::params::webapp_config_ensure,
  $webapp_config_keywords         = $portage::params::webapp_config_keywords,
  $webapp_config_keywords_version = $portage::params::webapp_config_keywords_version,
  $webapp_config_use              = $portage::params::webapp_config_use,
  $eselect_ensure                 = $portage::params::eselect_ensure,
  $eselect_keywords               = $portage::params::eselect_keywords,
  $eselect_keywords_version       = $portage::params::eselect_keywords_version,
  $eselect_use                    = $portage::params::eselect_use,
  $portage_utils_ensure           = $portage::params::portage_utils_ensure,
  $portage_utils_keywords         = $portage::params::portage_utils_keywords,
  $portage_utils_keywords_version = $portage::params::portage_utils_keywords_version,
  $portage_utils_use              = $portage::params::portage_utils_use,
  $emerge_command                 = $portage::params::emerge_command,
) inherits portage::params {

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
    exec { 'changed_makeconf':
      command     => "${emerge_command} -1 --changed-use $(qlist -vIC | sed \'s/^/=/\')",
      refreshonly => true,
      timeout     => 43200,
      provider    => shell,
      path        => ['/usr/local/sbin','/usr/local/bin',
                      '/usr/sbin','/usr/bin','/sbin','/bin'],
    }

    concat { $make_conf:
      owner => 'root',
      group => 'root',
      mode  => '0644',
    }

    if ($make_conf_remerge) {
      Concat[$make_conf] ~> Exec['changed_makeconf']
    }

    concat::fragment { 'makeconf_header':
      target  => $make_conf,
      content => template('portage/makeconf.header.conf.erb'),
      order   => '00',
    }
  }
}
