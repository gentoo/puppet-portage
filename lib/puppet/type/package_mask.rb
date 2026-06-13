# frozen_string_literal: true

require 'puppet/property/portage_version'
require 'puppet/property/portage_slot'
require 'puppet/parameter/portage_name'

Puppet::Type.newtype(:package_mask) do
  @doc = "Mask packages in portage.

      package_mask { 'app-admin/chef':
        target  => 'chef',
      }"

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true, parent: Puppet::Parameter::PortageName)

  newproperty(:version, parent: Puppet::Property::PortageVersion)

  newproperty(:slot, parent: Puppet::Property::PortageSlot)

  newproperty(:target) do
    desc 'The location of the package.mask file'

    defaultto do
      if @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile) # rubocop:disable Style/IfUnlessModifier
        @resource.class.defaultprovider.default_target
      end
    end

    # Allow us to not have to specify an absolute path unless we really want to
    munge do |value|
      value = "/etc/portage/package.mask/#{value}" unless value.match(%r{/})
      value
    end
  end
end
