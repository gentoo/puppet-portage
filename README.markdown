Puppet Gentoo Portage Module
============================

Provides Gentoo Portage features for Puppet.

[![Test](https://github.com/gentoo/puppet-portage/actions/workflows/test.yml/badge.svg)](https://github.com/gentoo/puppet-portage/actions/workflows/test.yml)

## /etc/portage/package.\*/\*

If `target` contains a `/`, then the value of `target` will used as-is.
Otherwise it will be prefixed with the relevant directory for that resource
type.

### package\_use

    package_use { 'app-admin/puppet':
      use     => ['flag1', 'flag2'],
      target  => 'puppet-flags',
      version => '>=3.0.1',
      ensure  => present,
    }

`use` can be either a string or an array of strings.

### package\_keywords

    package_keywords { 'app-admin/puppet':
      keywords => ['~x86', '-hppa'],
      target   => 'puppet',
      version  => '>=3.0.1',
      ensure   => present,
    }

`keywords` can be either a string or an array of strings.

### package\_unmask

    package_unmask { 'app-admin/puppet':
      target  => 'puppet',
      version => '>=3.0.1',
      ensure  => present,
    }

### package\_mask

    package_mask { 'app-admin/puppet':
      target  => 'tree',
      version => '>=3.0.1',
      ensure  => present,
    }

### package\_env

    package_env { 'www-client/firefox':
      env     => 'no-lto',
      target  => 'firefox',
      version => '>=20.0',
      ensure  => present,
    }

`env` can be either a string or an array of strings.

## make.conf

The default location of `make.conf` is `/etc/portage/make.conf`
If you want to change it, you should do the following:

    class { 'portage':
      make_conf = '/etc/make.conf',
    }

In order to add entries to `make.conf`:

    portage::makeconf { 'use':
      content => ['flag1', 'flag2'],
      ensure  => present,
    }

Changes in make.conf will also trigger re-emerge of the affected packages. You can disable this behaviour by setting `make_conf_remerge` to `false`.

## portage::package

This module provides a wrapper to the native package type:

    portage::package { 'app-admin/puppet':
      use              => ['-minimal', 'augeas'],
      use_version      => '>=3.0.1',
      keywords         => ['~amd64', '~x86'],
      keywords_version => '>=3.0.1',
      mask_version     => '<=2.3.17',
      unmask_version   => '>=3.0.1',
      target           => 'puppet',
      keywords_target  => 'puppet-keywords',
      ensure           => '3.0.1',
      emerge_command   => '/usr/bin/emerge',
    }

If no `{keywords,use,mask,unmask}\_target` is specified, then the value of `target`
is being used.  The variables keywords, mask and unmask also accept the special
value `all`, that will create versionless entries. (This applies only to
portage::package, if you want versionless entries in any of the above
`package\_\*` types, you can just omit the version attribute.) Any change in
`portage::package` will also trigger the appropriate re-emerge to the affected
package.

`emerge_command` allows special behavior for install & rebuild. The package
atom will be appended automatically. This allows installing packages with
`--oneshot`, and/or other emerge arguments.

## facts

All `make.conf` variables and most of the `eselect` modules are shown by `facter`

## eselect

The `eselect` type/provider checks for the current state of an `eselect` module
(or `gcc-config`) by reading the currently selected value.

    eselect { 'ruby':
      set => 'ruby19',
    }

Some eselect modules have special options or submodules:

    eselect { 'python::python2':
      set => 'python2.7',
    }

    eselect { 'php::apache2':
      set => 'php5.3',
    }

## webapp

The `webapp` type/provider can be used to manage webapps via `webapp-config`.

    webapp { 'www.example.org::/app':
      appname    => 'django',
      appversion => '1.4.5',
      server     => 'nginx',
      user       => 'nginx',
      group      => 'nginx',
      secure     => 'yes',
    }

## Installation of Gentoo tools

This module can also handle the installation of various Gentoo tools.

    class { 'portage':
      portage_ensure => '2.2.6',
      eix_ensure     => '0.29.4',
      eix_keywords   => ['~amd64', '~x86'],
    }

See `manifests/init.pp` for all the available tools that can be defined.
(It is recommended to use hiera in order to define the values)

See Also
--------

  * man 5 portage: http://www.linuxmanpages.com/man5/portage.5.php
  * man 5 ebuild: http://www.linuxmanpages.com/man5/ebuild.5.php

Contributors
============

  * [Lance Albertson](https://github.com/ramereth)
  * [Russell Haering](https://github.com/russellhaering)
  * [Adrien Thebo](https://github.com/adrienthebo)
  * [Theo Chatzimichos](https://github.com/tampakrap)
  * [John-John Tedro](https://github.com/udoprog)
  * [Vikraman Choudhury](https://github.com/vikraman)
  * [Matthias Saou](https://github.com/thias)
  * [Garrett Honeycutt](http://learnpuppet.com)
  * [Robin Johnson](https://github.com/robbat2)
