# @summary
#   Configures and install portage backed packages
#
# @param ensure
#   The ensure value of the package.
#
# @param use
#   Use flags for the package.
#
# @param keywords
#   Portage keywords for the package.
#
# @param accept_keywords
#   Portage accept_keywords for the package.
#
# @param target
#   A default value for package.* targets
#
# @param use_target
#   An optional custom target for package use flags
#
# @param keywords_target
#   An optional custom target for package keywords
#
# @param accept_keywords_target
#   An optional custom target for package accept_keywords
#
# @param mask_target
#   An optional custom target for package masks
#
# @param unmask_target
#   An optional custom target for package unmasks
#
# @param use_version
#   An optional version specification for package use
#
# @param use_slot
#   An optional slot specification for package use
#
# @param keywords_version
#   An optional version specification for package keywords
#
# @param keywords_slot
#   An optional slot specification for package keywords
#
# @param accept_keywords_version
#   An optional version specification for package accept_keywords
#
# @param accept_keywords_slot
#   An optional slot specification for package accept_keywords
#
# @param mask_version
#   An optional version specification for package mask
#
# @param mask_slot
#   An optional slot specification for package mask
#
# @param unmask_version
#   An optional version specification for package unmask
#
# @param unmask_slot
#   An optional slot specification for package unmask
#
# @example
#   portage::package { 'app-admin/puppet':
#     ensure       => '3.0.1',
#     use          => ['augeas', '-rrdtool'],
#     accept_keywords     => '~amd64',
#     target       => 'puppet',
#     mask_version => '<=2.7.18',
#   }
#
# @see `puppet describe package_use`
# @see `puppet describe package_keywords`
# @see `puppet describe package_accept_keywords`
# @see `puppet describe package_mask`
# @see `puppet describe package_unmask`
#
define portage::package (
  Stdlib::Ensure::Package $ensure = 'present',
  Optional[String] $target = undef,

  Optional[Array[Pattern[/\A\S+\z/]]] $use = undef,
  Optional[String] $use_version = undef,
  Optional[String] $use_slot = undef,
  Optional[String] $use_target = undef,

  Optional[Array[Pattern[/\A\S+\z/]]] $accept_keywords = undef,
  Optional[String] $accept_keywords_version = undef,
  Optional[String] $accept_keywords_slot = undef,
  Optional[String] $accept_keywords_target = undef,

  Optional[String] $mask_version = undef,
  Optional[String] $mask_slot = undef,
  Optional[String] $mask_target = undef,

  Optional[String] $unmask_version = undef,
  Optional[String] $unmask_slot = undef,
  Optional[String] $unmask_target = undef,
) {
  $atom = $ensure ? {
    /(present|absent|purged|held|installed|latest)/ => $name,
    /./ => "=${name}-${ensure}",
    default => $name,
  }

  $removing = $ensure ? {
    /(absent|purged)/ => true,
    default => false,
  }

  $assigned_use_target = pick($use_target, $target)
  $assigned_accept_keywords_target = pick($accept_keywords_target, $target)
  $assigned_mask_target = pick($mask_target, $target)
  $assigned_unmask_target = pick($unmask_target, $target)

  if($use and !$removing) {
    package_use { $name:
      use     => $use,
      version => $use_version,
      slot    => $use_slot,
      target  => $assigned_use_target,
      notify  => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }
  else {
    package_use { $name:
      ensure => absent,
      target => $assigned_use_target,
      notify => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }

  if(!$removing and ($accept_keywords or $accept_keywords_version)) {
    if $accept_keywords == 'all' {
      $assigned_accept_keywords = undef
    }
    else {
      $assigned_accept_keywords = $accept_keywords
    }
    package_accept_keywords { $name:
      accept_keywords => $assigned_accept_keywords,
      version         => $accept_keywords_version,
      slot            => $accept_keywords_slot,
      target          => $assigned_accept_keywords_target,
      notify          => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }
  else {
    package_accept_keywords { $name:
      ensure => absent,
      target => $assigned_accept_keywords_target,
      notify => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }

  if(!$removing and ($mask_version or $mask_slot)) {
    if $mask_version == 'all' {
      $assigned_mask_version = undef
    }
    else {
      $assigned_mask_version = $mask_version
    }
    package_mask { $name:
      version => $assigned_mask_version,
      slot    => $mask_slot,
      target  => $assigned_mask_target,
      notify  => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }
  else {
    package_mask { $name:
      ensure => absent,
      target => $assigned_mask_target,
      notify => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }

  if(!$removing and ($unmask_version or $unmask_slot)) {
    if $unmask_version == 'all' {
      $assigned_unmask_version = undef
    }
    else {
      $assigned_unmask_version = $unmask_version
    }
    package_unmask { $name:
      version => $assigned_unmask_version,
      slot    => $unmask_slot,
      target  => $assigned_unmask_target,
      notify  => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }
  else {
    package_unmask { $name:
      ensure => absent,
      target => $assigned_unmask_target,
      notify => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }

  $rebuild_command = $removing ? {
    true  => '/bin/true',
    false => "${portage::emerge_command} --changed-use -u1 ${atom}",
    default  => '/bin/false Should-Not-Trigger', # This should not happen.
  }

  exec { "rebuild_${atom}":
    command     => $rebuild_command,
    refreshonly => true,
    timeout     => 43200,
    # Emerge inherits the path, so it must be valid.
    path        => ['/usr/local/sbin','/usr/local/bin',
    '/usr/sbin','/usr/bin','/sbin','/bin'],
  }

  package { $name:
    ensure => $ensure,
  }
}
