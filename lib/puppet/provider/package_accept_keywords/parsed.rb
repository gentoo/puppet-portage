# frozen_string_literal: true

require 'puppet/provider/portagefile'
require 'puppet/util/portage'

Puppet::Type.type(:package_accept_keywords).provide(:parsed,
                                                    parent: Puppet::Provider::PortageFile,
                                                    default_target: '/etc/portage/package.accept_keywords/default',
                                                    filetype: :flat) do
  desc 'The package_accept_keywords provider that uses the ParsedFile class'
  text_line :comment, match: %r{^\s*#}
  text_line :blank, match: %r{^\s*$}
  record_line :parsed, fields: %w[name accept_keywords], joiner: ' ', rts: true do |line|
    Puppet::Provider::PortageFile.process_line(line, :accept_keywords)
  end

  # Define the ParsedFile format hook
  #
  # @param [Hash] hash
  #
  # @return [String]
  def self.to_line(hash)
    return super unless hash[:record_type] == :parsed

    build_line(hash, :accept_keywords)
  end
end
