# frozen_string_literal: true

require 'puppet/util/portage'
require 'puppet/property'

class Puppet::Property::PortageVersion < Puppet::Property
  desc 'A properly formatted version string'

  validate do |value|
    unless Puppet::Util::Portage.valid_version? value # rubocop:disable Style/IfUnlessModifier
      raise ArgumentError, "'#{value}' must be a properly formatted version"
    end
  end
end
