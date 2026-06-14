# frozen_string_literal: true

module Puppet::Util::Webapp
  # Util methods for Webapp types and providers.
  #
  # @see 'man webapp-config'

  module_function

  NAME_PATTERN = '(\S+)::(\/?\S*)'
  PATH_PATTERN = '\S*\/(\S+)\/htdocs(-secure)?(\/\S*)?'
  APP_PATTERN  = '(\S+)\s(\S+)'

  NAME_REGEX = Regexp.new "^#{NAME_PATTERN}$"
  PATH_REGEX = Regexp.new "^#{PATH_PATTERN}$"
  APP_REGEX  = Regexp.new "^#{APP_PATTERN}$"

  # Determine if a string is a valid webapp name
  #
  # @param [String] name The string to validate as a webapp name
  #
  # @return [TrueClass]
  # @return [FalseClass]
  def valid_name?(name)
    !!(name =~ NAME_REGEX)
  end

  # Determine if a string is a valid webapp path
  #
  # @param [String] name The string to validate as a webapp path
  #
  # @return [TrueClass]
  # @return [FalseClass]
  def valid_path?(path)
    !!(path =~ PATH_REGEX)
  end

  # Determine if a string is a valid app
  #
  # @param [String] name The string to validate as an app
  #
  # @return [TrueClass]
  # @return [FalseClass]
  def valid_app?(app)
    !!(app =~ APP_REGEX)
  end

  # Fix empty directory strings
  #
  # @param [String] dir A directory string
  #
  # @return [String] Fixed directory string
  def fix_dir(dir)
    ((dir.nil? || dir.empty?) && '/') || dir
  end

  # Build webapp-config options from webapp properties
  #
  # @param [Hash] Properties of a webapp
  #
  # @return [Array] Options to pass to webapp-config
  def build_opts(hash, *args)
    opts = args
    hash.each do |key, value|
      case key
      when :secure, :soft
        value == :yes && (opts << "--#{key}")
      else
        opts << "--#{key}" << value
      end
    end
    opts << hash[:appname]
    opts << hash[:appversion]
    opts.compact
  end

  # Parse a webapp name into host and dir
  #
  # @param [String] A webapp name
  #
  # @return [Hash] Parsed host and dir values
  def parse_name(name)
    if (match = name.match(NAME_REGEX))
      {
        host: match[1],
        dir: fix_dir(match[2]),
      }
    else
      raise WebappError, "#{name} is not a valid webapp name"
    end
  end

  # Parse a webapp path into webapp properties
  #
  # @param [String] A webapp installed path
  #
  # @return [Hash] Parsed webapp properties
  def parse_path(path)
    if (match = path.match(PATH_REGEX))
      host = match[1]
      secure = match[2]
      dir = fix_dir(match[3])
      {
        name: format('%s::%s', host, dir),
        host: host,
        dir: dir,
        secure: (secure.nil? && :no) || :yes,
      }
    else
      raise WebappError, "#{path} is not a valid webapp path"
    end
  end

  # Parse an app into appname and appversion
  #
  # @param [String] An app string
  #
  # @return [Hash] Parsed appname and appversion
  def parse_app(app)
    if (match = app.match(APP_REGEX))
      {
        appname: match[1],
        appversion: match[2],
      }
    else
      raise WebappError, "#{app} is not a valid app string"
    end
  end

  # Parse a webapp resource into webapp properties
  #
  # @param [Hash] A webapp resource
  #
  # @return [Hash] Parsed webapp properties
  def parse_resource(resource)
    webapp = parse_name(resource[:name])
    keys = %i[appname appversion server user group soft secure]
    keys.each do |key|
      resource[key] && webapp[key] = resource[key]
    end
    webapp
  end

  # Format webapp properties to a webapp name
  #
  # @param [Hash] Properties of a webapp
  #
  # @return [String] The webapp name
  def format_webapp(hash)
    format('%s::%s', hash[:host], hash[:dir])
  end

  class WebappError < RuntimeError; end
end
