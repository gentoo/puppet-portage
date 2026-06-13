# frozen_string_literal: true

require 'puppet/property/portage_version'
require 'puppet/property/portage_slot'
require 'puppet/parameter/portage_name'

Puppet::Type.newtype(:package_accept_keywords) do
  @doc = "Set accept_keywords for a package.

      package_accept_keywords { 'app-admin/puppet':
        accept_keywords  => ['~x86', '-hppa'],
        target  => 'puppet',
      }"

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true, parent: Puppet::Parameter::PortageName)

  newproperty(:version, parent: Puppet::Property::PortageVersion)

  newproperty(:slot, parent: Puppet::Property::PortageSlot)

  newproperty(:accept_keywords) do
    desc 'The accept_keywords(s) to use'

    defaultto []

    validate do |value|
      raise ArgumentError, 'Keyword cannot contain whitespace' if value =~ %r{\s}
    end

    def insync?(is)
      is == should
    end

    def should
      return nil unless defined? @should

      flattened = @should.flatten
      return :absent if flattened == [:absent]

      flattened.reject(&:empty?)
    end

    def should_to_s(newvalue = @should)
      newvalue.join(' ')
    end

    def is_to_s(currentvalue = @is)
      currentvalue = [currentvalue] unless currentvalue.is_a? Array
      currentvalue.join(' ')
    end
  end

  newproperty(:target) do
    desc 'The location of the package.accept_keywords file'

    defaultto do
      if @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile) # rubocop:disable Style/IfUnlessModifier
        @resource.class.defaultprovider.default_target
      end
    end

    # Allow us to not have to specify an absolute path unless we really want to
    munge do |value|
      value = "/etc/portage/package.accept_keywords/#{value}" unless value.match(%r{/})
      value
    end
  end
end
