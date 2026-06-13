# frozen_string_literal: true

require 'puppet/provider/portagefile'
require 'puppet/util/portage'

Puppet::Type.type(:package_unmask).provide(:parsed,
                                           parent: Puppet::Provider::PortageFile,
                                           default_target: '/etc/portage/package.unmask/default',
                                           filetype: :flat) do
  desc 'The package_unmask provider backed by parsedfile'
  text_line :comment, match: %r{^\s*#}
  text_line :blank, match: %r{^\s*$}
  record_line :parsed, fields: %w[name], rts: true do |line|
    Puppet::Provider::PortageFile.process_line(line)
  end
end
