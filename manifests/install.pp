class portage::install {
  include portage

  portage::package { 'sys-apps/portage':
    ensure           => $portage::portage_ensure,
    keywords         => $portage::portage_keywords,
    keywords_version => $portage::portage_keywords_version,
    use              => $portage::portage_use,
    target           => 'portage',
  }

  portage::package { 'app-portage/eix':
    ensure           => $portage::eix_ensure,
    keywords         => $portage::eix_keywords,
    keywords_version => $portage::eix_keywords_version,
    use              => $portage::eix_use,
    target           => 'portage',
  }

  portage::package { 'app-admin/webapp-config':
    ensure           => $portage::webapp_config_ensure,
    keywords         => $portage::webapp_config_keywords,
    keywords_version => $portage::webapp_config_keywords_version,
    use              => $portage::webapp_config_use,
    target           => 'portage',
  }

  portage::package { 'app-admin/eselect':
    ensure           => $portage::eselect_ensure,
    keywords         => $portage::eselect_keywords,
    keywords_version => $portage::eselect_keywords_version,
    use              => $portage::eselect_use,
    target           => 'portage',
  }

  portage::package { 'app-portage/portage-utils':
    ensure           => $portage::portage_utils_ensure,
    keywords         => $portage::portage_utils_keywords,
    keywords_version => $portage::portage_utils_keywords_version,
    use              => $portage::portage_utils_use,
    target           => 'portage',
  }
}
