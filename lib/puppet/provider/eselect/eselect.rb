# frozen_string_literal: true

Puppet::Type.type(:eselect).provide(:eselect) do
  confine 'os.family' => 'Gentoo'

  commands eselect: '/usr/bin/eselect'

  def self.instances
    Facter.value(:eselect).keys
  end

  def set
    self.class.run_action_on_module(resource[:name], :get)
  end

  def set=(target)
    self.class.run_action_on_module(resource[:name], :set, target)
    self.class.run_action_on_module(resource[:name], :get)
  end

  # Builds a module combining the default and special modules
  #
  # @param [String] name The name of the module
  #
  # @return [Hash]:
  #   * command [Symbol] The command used to manage this module
  #   * flags [Array<String>] The flags to pass to the command
  #   * param [String] The param to be passed after flags, or nil
  #   * get [Array[String]] The flags to be passed to get the state of the module
  #   * set [Array[String]] The flags to be passed to set the state of the module
  #   * parse [Proc] The function to parse the command output
  def self.module(name)
    default_module(name).merge(CUSTOM_MODULES[name] || {})
  end

  # Run the action on the module and return the parsed output
  #
  # @param [String] name The name of the module
  # @param [Symbol] action The action to run, `:get` or `:set`
  # @param [String] args Extra arguments to be passed
  #
  # @return [String] The parsed output of the action
  # @example Set the default Ruby to be 1.9
  #   run_action_on_module(ruby', :set, 'ruby19')
  #   #=> "ruby19"
  def self.run_action_on_module(name, action, *args)
    mod = self.module(name)
    args = mod[:flags] + [mod[:param]] + mod[action] + args
    output = send(mod[:command], args.flatten.compact)
    mod[:parse].call(output) if action == :get
  end

  CUSTOM_MODULES = { # rubocop:disable Lint/ConstantDefinitionInBlock
    'java-vm' => {
      get: %w[show system],
      set: %w[set system],
    },
  }.merge(%w[cli apache2 fpm cgi phpdbg].to_h do |x|
            ["php::#{x}", {
              param: 'php',
              get: ['show', x],
              set: ['set', x],
            },]
          end)

  private

  def self.default_module(name)
    {
      command: :eselect,
      flags: ['--brief', '--color=no'],
      param: name,
      get: ['show'],
      set: ['set'],
      parse: proc(&:strip),
    }
  end
end
