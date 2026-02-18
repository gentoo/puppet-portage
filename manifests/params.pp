# = Class: portage::params
#
# Contains default values for portage.
#
# == Example
#
# This class does not need to be directly included.
#
class portage::params {
  $make_conf                      = '/etc/portage/make.conf'
  $make_conf_remerge              = true
  $portage_ensure                 = installed
  $portage_keywords               = undef
  $portage_keywords_version       = undef
  $portage_use                    = undef
  $eix_ensure                     = installed
  $eix_keywords                   = undef
  $eix_keywords_version           = undef
  $eix_use                        = undef
  $webapp_config_ensure           = absent
  $webapp_config_keywords         = undef
  $webapp_config_keywords_version = undef
  $webapp_config_use              = undef
  $eselect_ensure                 = absent
  $eselect_keywords               = undef
  $eselect_keywords_version       = undef
  $eselect_use                    = undef
  $portage_utils_ensure           = installed
  $portage_utils_keywords         = undef
  $portage_utils_keywords_version = undef
  $portage_utils_use              = undef
  $emerge_command                 = '/usr/bin/emerge'
}
