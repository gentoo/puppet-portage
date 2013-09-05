require File.expand_path(File.join(File.dirname(__FILE__),'..','portagefile'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','util','portage'))

Puppet::Type.type(:package_unmask).provide(:parsed,
  :parent => Puppet::Provider::PortageFile,
  :default_target => "/etc/portage/package.unmask/default",
  :filetype => :flat
) do

  desc "The package_unmask provider backed by parsedfile"

  record_line :parsed, :fields => %w{name}, :rts => true do |line|
    Puppet::Provider::PortageFile.process_line(line)
  end
end
