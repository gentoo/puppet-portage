# frozen_string_literal: true

require 'puppet/util/portage'
require 'puppet/parameter'

class Puppet::Parameter::PortageName < Puppet::Parameter
  desc 'The package name'

  validate do |value|
    unless Puppet::Util::Portage.valid_package? value # rubocop:disable Style/IfUnlessModifier
      raise ArgumentError, "#{name} must be a properly formatted atom, see portage(5) for more information"
    end
  end
end
