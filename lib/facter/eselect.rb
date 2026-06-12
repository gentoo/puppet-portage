# frozen_string_literal: true

Facter.add(:eselect) do
  confine do
    Facter.value(:os)['family'] == 'Gentoo'
  end

  setcode do
    eselect_cmd = '/usr/bin/eselect --brief --color=no'
    eselect_modules_blacklist = %w[
      help usage version bashcomp env fontconfig modules
      news rc arptables ebtables
    ]
    eselect_modules_multitarget = {
      'php' => %w[cli apache2 fpm cgi phpdbg],
    }

    eselect_modules = Facter::Core::Execution.execute("#{eselect_cmd} modules list --only-names")
                                             .split("\n")
                                             .map(&:strip)
                                             .reject(&:empty?)
    eselect_modules -= eselect_modules_blacklist

    eselect = {}
    eselect_modules.each do |eselect_module|
      help_output = Facter::Core::Execution.execute("#{eselect_cmd} #{eselect_module} help")
                                           .split("\n")
                                           .map(&:strip)
                                           .reject(&:empty?)
                                           .map { |s| s.split[0] }

      next unless help_output.include?('show')

      if (submodules = eselect_modules_multitarget[eselect_module])
        eselect[eselect_module] = {}
        submodules.each do |target|
          output = Facter::Core::Execution.execute("#{eselect_cmd} #{eselect_module} show #{target}").strip
          eselect[eselect_module][target] = output unless ['(none)', '(unset)'].include? output
        end
      else
        output = Facter::Core::Execution.execute("#{eselect_cmd} #{eselect_module} show").strip.split[0]
        eselect[eselect_module] = output unless ['(none)', '(unset)'].include? output
      end
    end

    eselect
  end
end
