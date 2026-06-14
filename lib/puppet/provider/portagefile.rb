# frozen_string_literal: true

require 'puppet/util/portage'
require 'puppet/provider/parsedfile'

# Common base class for gentoo package_* providers. It aggregates some of the
# boilerplate that's shared between the providers.
class Puppet::Provider::PortageFile < Puppet::Provider::ParsedFile
  text_line :comment, match: %r{^#}
  text_line :blank, match: %r{^\s*$}

  def flush
    # Ensure the target directory exists before creating file
    unless File.exist?(dir = File.dirname(target))
      Dir.mkdir(dir)
    end
    super
    File.chmod(0o644, target)
  end

  def self.build_line(hash, sym = nil)
    raise ArgumentError, 'name is a required attribute of portagefile providers' unless hash[:name] && (hash[:name] != :absent)

    str = Puppet::Util::Portage.format_atom(hash)

    if !sym.nil? && hash.include?(sym)
      str << ' ' << if hash[sym].is_a? Array
                      hash[sym].join(' ')
                    else
                      hash[sym]
                    end
    end
    str
  end

  # Define the :process FileRecord hook
  #
  # @param [String] line
  # @param [Symbol] attribute
  #
  # @return [Hash]
  def self.process_line(line, attribute = nil)
    hash = {}

    if !attribute.nil? && (match = line.match(%r{^(\S+)\s+(.*)\s*$}))
      # if we have a package and an array of attributes.

      components = Puppet::Util::Portage.parse_atom(match[1])

      # Try to parse version string
      v = components[:compare] + components[:version] if components[:compare] && components[:version]

      hash[:name]    = components[:package]
      hash[:version] = v

      hash[:slot] = components[:slot].dup if components[:slot]

      attr_array = match[2].split(%r{\s+})
      hash[attribute] = attr_array

    elsif (match = line.match(%r{^(\S+)\s*}))
      # just a package
      components = Puppet::Util::Portage.parse_atom(match[1])

      # Try to parse version string
      v = components[:compare] + components[:version] if components[:compare] && components[:version]

      hash[:name]    = components[:package]
      hash[:version] = v

      hash[:slot] = components[:slot].dup if components[:slot]

    else
      raise Puppet::Error, "Could not match '#{line}'"
    end

    hash
  end

  # Define the ParsedFile format hook
  #
  # @param [Hash] hash
  #
  # @return [String]
  def self.to_line(hash)
    return super unless hash[:record_type] == :parsed

    build_line(hash)
  end
end
