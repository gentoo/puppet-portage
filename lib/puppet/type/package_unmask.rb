# frozen_string_literal: true

require 'puppet/property/portage_version'
require 'puppet/property/portage_slot'
require 'puppet/parameter/portage_name'

Puppet::Type.newtype(:package_unmask) do
  @doc = "Unmask packages in portage.

      package_unmask { 'app-admin/puppet-2.7.1':
        target  => 'puppet',
      }"

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true, parent: Puppet::Parameter::PortageName)

  newproperty(:version, parent: Puppet::Property::PortageVersion)

  newproperty(:slot, parent: Puppet::Property::PortageSlot)

  newproperty(:target) do
    desc 'The location of the package.unmask file'

    defaultto do
      if @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile) # rubocop:disable Style/IfUnlessModifier
        @resource.class.defaultprovider.default_target
      end
    end

    # Allow us to not have to specify an absolute path unless we really want to
    munge do |value|
      value = "/etc/portage/package.unmask/#{value}" unless value.match(%r{/})
      value
    end
  end
end
