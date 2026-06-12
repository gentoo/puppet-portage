# frozen_string_literal: true

def parse_repo_section(output, header)
  start = output.lines.index { |l| l.start_with?(header) }
  return {} unless start

  repos = {}
  current_repo = nil

  output.lines[(start + 1)..].each do |line|
    next if line.rstrip.empty?

    if line =~ %r{^[ \t]+(\S[^:]*):\s*(.*)$} # Match repository configuration
      current_repo[Regexp.last_match(1).strip] = Regexp.last_match(2).strip if current_repo
    elsif line =~ %r{^(\S+)\s*$} # Match repository names
      break if line.include?('=') || line.include?(':')

      current_repo = {}
      repos[Regexp.last_match(1)] = current_repo
    else
      break
    end
  end

  repos
end

Facter.add(:portage) do
  confine do
    Facter.value(:os)['family'] == 'Gentoo'
  end

  setcode do
    output = Facter::Core::Execution.exec('/usr/bin/emerge --info')

    values = output.scan(%r{[0-9A-Z_]+=".+?"})

    portage = values.each_with_object({}) do |string, hash|
      match = string.match(%r{(.*)="(.*)"})
      key = match[1].downcase
      val = match[2]
      hash[key] = val
    end

    portage['repositories'] = parse_repo_section(output, 'Repositories:')
    portage['binary_repositories'] = parse_repo_section(output, 'Binary Repositories:')

    portage
  end
end
