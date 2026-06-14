# Class: portage::install
#
# @summary
#   Installs and configures the core Portage userland tools (portage, eix,
#   webapp-config, eselect, and portage-utils).
#
# @param portage_ensure
#   Ensure state for sys-apps/portage.
#
# @param eix_ensure
#   Ensure state for app-portage/eix.
#
# @param webapp_config_ensure
#   Ensure state for app-admin/webapp-config.
#
# @param eselect_ensure
#   Ensure state for app-admin/eselect.
#
# @param portage_utils_ensure
#   Ensure state for app-portage/portage-utils.
#
# @param portage_accept_keywords
#   accept_keywords entries (e.g. `~amd64`) for sys-apps/portage.
#
# @param portage_use
#   USE flags for sys-apps/portage.
#
# @param portage_accept_keywords_version
#   Version `$portage_accept_keywords` applies to. Unset applies to all versions.
#
# @param eix_accept_accept_keywords
#   accept_keywords entries (e.g. `~amd64`) for app-portage/eix.
#
# @param eix_use
#   USE flags for app-portage/eix.
#
# @param eix_accept_keywords_version
#   Version `$eix_accept_accept_keywords` applies to. Unset applies to all versions.
#
# @param webapp_config_accept_keywords
#   accept_keywords entries (e.g. `~amd64`) for app-admin/webapp-config.
#
# @param webapp_config_use
#   USE flags for app-admin/webapp-config.
#
# @param webapp_config_accept_keywords_version
#   Version `$webapp_config_accept_keywords` applies to. Unset applies to all versions.
#
# @param eselect_accept_keywords
#   accept_keywords entries (e.g. `~amd64`) for app-admin/eselect.
#
# @param eselect_use
#   USE flags for app-admin/eselect.
#
# @param eselect_accept_keywords_version
#   Version `$eselect_accept_keywords` applies to. Unset applies to all versions.
#
# @param portage_utils_accept_keywords
#   accept_keywords entries (e.g. `~amd64`) for app-portage/portage-utils.
#
# @param portage_utils_use
#   USE flags for app-portage/portage-utils.
#
# @param portage_utils_accept_keywords_version
#   Version `$portage_utils_accept_keywords` applies to. Unset applies to all versions.
#
class portage::install (
  Stdlib::Ensure::Package $portage_ensure,
  Stdlib::Ensure::Package $eix_ensure,
  Stdlib::Ensure::Package $webapp_config_ensure,
  Stdlib::Ensure::Package $eselect_ensure,
  Stdlib::Ensure::Package $portage_utils_ensure,

  Optional[Array[Pattern[/\A\S+\z/]]] $portage_accept_keywords = undef,
  Optional[Array[Pattern[/\A\S+\z/]]] $portage_use = undef,
  Optional[String] $portage_accept_keywords_version = undef,

  Optional[Array[Pattern[/\A\S+\z/]]] $eix_accept_accept_keywords = undef,
  Optional[Array[Pattern[/\A\S+\z/]]] $eix_use = undef,
  Optional[String] $eix_accept_keywords_version = undef,

  Optional[Array[Pattern[/\A\S+\z/]]] $webapp_config_accept_keywords = undef,
  Optional[Array[Pattern[/\A\S+\z/]]] $webapp_config_use = undef,
  Optional[String] $webapp_config_accept_keywords_version = undef,

  Optional[Array[Pattern[/\A\S+\z/]]] $eselect_accept_keywords = undef,
  Optional[Array[Pattern[/\A\S+\z/]]] $eselect_use = undef,
  Optional[String] $eselect_accept_keywords_version = undef,

  Optional[Array[Pattern[/\A\S+\z/]]] $portage_utils_accept_keywords = undef,
  Optional[Array[Pattern[/\A\S+\z/]]] $portage_utils_use = undef,
  Optional[String] $portage_utils_accept_keywords_version = undef,
) {
  portage::package { 'sys-apps/portage':
    ensure                  => $portage_ensure,
    accept_keywords         => $portage_accept_keywords,
    accept_keywords_version => $portage_accept_keywords_version,
    use                     => $portage_use,
    target                  => 'portage',
  }

  portage::package { 'app-portage/eix':
    ensure                  => $eix_ensure,
    accept_keywords         => $eix_accept_accept_keywords,
    accept_keywords_version => $eix_accept_keywords_version,
    use                     => $eix_use,
    target                  => 'portage',
  }

  portage::package { 'app-admin/webapp-config':
    ensure                  => $webapp_config_ensure,
    accept_keywords         => $webapp_config_accept_keywords,
    accept_keywords_version => $webapp_config_accept_keywords_version,
    use                     => $webapp_config_use,
    target                  => 'portage',
  }

  portage::package { 'app-admin/eselect':
    ensure                  => $eselect_ensure,
    accept_keywords         => $eselect_accept_keywords,
    accept_keywords_version => $eselect_accept_keywords_version,
    use                     => $eselect_use,
    target                  => 'portage',
  }

  portage::package { 'app-portage/portage-utils':
    ensure                  => $portage_utils_ensure,
    accept_keywords         => $portage_utils_accept_keywords,
    accept_keywords_version => $portage_utils_accept_keywords_version,
    use                     => $portage_utils_use,
    target                  => 'portage',
  }
}
