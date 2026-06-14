# frozen_string_literal: true

module Puppet::Util::Portage
  # Util methods for Portage types and providers.
  #
  # @see http://dev.gentoo.org/~zmedico/portage/doc/man/ebuild.5.html 'man 5 ebuild section DEPEND'
  # @see http://dev.gentoo.org/~ulm/pms/head/pms.html 'section 3'

  module_function

  CATEGORY_PATTERN = '[\w+][\w+.-]*'
  NAME_PATTERN     = '[\w+][\w+-]*?'
  PACKAGE_PATTERN  = "(#{CATEGORY_PATTERN}/#{NAME_PATTERN})"
  COMPARE_PATTERN  = '([<>=~]|[<>]=)'
  VERSION_PATTERN  = '((?:cvs\.)?(?:\d+)(?:(?:\.\d+)*)(?:[a-z]?)(?:(?:_(?:pre|p|beta|alpha|rc)\d*)*)(?:-r(?:\d+))?)'
  WILDCARD_PATTERN = "(#{VERSION_PATTERN}\\*)"
  SLOT_PATTERN     = '([\w+./*=-]+)'

  BASE_ATOM_REGEX              = Regexp.new "^#{PACKAGE_PATTERN}$"
  VERSIONED_ATOM_REGEX         = Regexp.new "^#{COMPARE_PATTERN}#{PACKAGE_PATTERN}-#{VERSION_PATTERN}$"
  SLOTTED_ATOM_REGEX           = Regexp.new "^#{PACKAGE_PATTERN}:#{SLOT_PATTERN}$"
  VERSIONED_SLOTTED_ATOM_REGEX = Regexp.new "^#{COMPARE_PATTERN}#{PACKAGE_PATTERN}-#{VERSION_PATTERN}:#{SLOT_PATTERN}$"
  WILDCARD_ATOM_REGEX          = Regexp.new "^(=?)#{PACKAGE_PATTERN}-#{WILDCARD_PATTERN}$"
  WILDCARD_SLOTTED_ATOM_REGEX  = Regexp.new "^(=?)#{PACKAGE_PATTERN}-#{WILDCARD_PATTERN}:#{SLOT_PATTERN}$"
  DEPEND_ATOM_REGEX            = Regexp.union BASE_ATOM_REGEX, VERSIONED_ATOM_REGEX, SLOTTED_ATOM_REGEX, VERSIONED_SLOTTED_ATOM_REGEX, WILDCARD_ATOM_REGEX, WILDCARD_SLOTTED_ATOM_REGEX

  # Determine if a string is a valid DEPEND atom
  #
  # @param [String] atom The string to validate as a DEPEND atom
  #
  # @return [TrueClass]
  # @return [FalseClass]
  def valid_atom?(atom)
    # Normalize the regular expression output to a boolean
    !!(atom =~ DEPEND_ATOM_REGEX)
  end

  # Determine if a string is a valid package name
  #
  # @param [String] package_name the string to validate as a package name
  #
  # @return [TrueClass]
  # @return [FalseClass]
  def valid_package?(package_name)
    !!(package_name =~ BASE_ATOM_REGEX)
  end

  # Determine if a string is a valid DEPEND atom version
  #
  # This validates a standalone version string. The format is an optional
  # comparator and a version string.
  #
  # @param [String] version_str The string to validate as a version string.
  #
  # @return [TrueClass]
  # @Return [FalseClass]
  def valid_version?(version_str)
    regex = Regexp.new "^#{COMPARE_PATTERN}?#{VERSION_PATTERN}$|^=?#{WILDCARD_PATTERN}$"
    !!(version_str =~ regex)
  end

  # Determine if a string is a valid DEPEND atom slot
  #
  # This validates a standalone slot string.
  #
  # @param [String] slot_str The string to validate as a slot string.
  #
  # @return [TrueClass]
  # @Return [FalseClass]
  def valid_slot?(slot_str)
    regex = Regexp.new "^#{SLOT_PATTERN}$"
    !!(slot_str =~ regex)
  end

  # Parse a string into the different components of a DEPEND atom.
  #
  # If the atom is versioned, the returned value will contain the keys
  # :package, :compare, and :version. If the atom is unversioned then it will
  # contain the key :package. If the atom is slotted then it will contain the
  # key :slot.
  #
  # @raise [Puppet::Util::Portage::AtomError]
  #
  # @param [String] atom The string to parse
  #
  # @return [Hash<Symbol, String>] The parsed values
  def parse_atom(atom)
    if (match = atom.match(BASE_ATOM_REGEX))
      { package: match[1] }
    elsif (match = atom.match(VERSIONED_ATOM_REGEX))
      { compare: match[1] || '=', package: match[2], version: match[3] }
    elsif (match = atom.match(WILDCARD_ATOM_REGEX))
      { compare: match[1], package: match[2], version: match[3] }
    elsif (match = atom.match(SLOTTED_ATOM_REGEX))
      { package: match[1], slot: match[2] }
    elsif (match = atom.match(VERSIONED_SLOTTED_ATOM_REGEX))
      { compare: match[1] || '=', package: match[2], version: match[3], slot: match[4] }
    elsif (match = atom.match(WILDCARD_SLOTTED_ATOM_REGEX))
      { compare: match[1], package: match[2], version: match[3], slot: match[4] }
    else
      raise AtomError, "#{atom} is not a valid atom"
    end
  end

  # Parse out a combined compare and version into a hash
  #
  # @return [Hash]
  def parse_cmpver(cmpver)
    version_regex = Regexp.new "^#{COMPARE_PATTERN}?#{VERSION_PATTERN}$"
    wildcard_regex = Regexp.new "^(=?)#{WILDCARD_PATTERN}$"
    if (match = cmpver.match version_regex)
      { compare: match[1] || '=', version: match[2] }
    elsif (match = cmpver.match wildcard_regex)
      { compare: match[1], version: match[2] }
    else
      raise AtomError, "#{cmpver} is not a valid compare version"
    end
  end

  # Convert a hash describing an atom into a string
  #
  # @return [String]
  def format_atom(hash)
    str = String.new

    if hash[:version]
      ver_hash = parse_cmpver(hash[:version])
      str << ver_hash[:compare]
      str << hash[:name]
      str << '-'
      str << ver_hash[:version]
    else
      str = hash[:name].dup
    end
    if hash[:slot]
      str << ':'
      str << hash[:slot]
    end

    str
  end

  class AtomError < RuntimeError; end
end
