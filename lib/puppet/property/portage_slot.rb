# frozen_string_literal: true

require 'puppet/util/portage'
require 'puppet/property'

class Puppet::Property::PortageSlot < Puppet::Property
  desc 'A properly formatted slot string'

  validate do |value|
    unless Puppet::Util::Portage.valid_slot? value # rubocop:disable Style/IfUnlessModifier
      raise ArgumentError, "#{name} must be a properly formatted slot"
    end
  end
end
