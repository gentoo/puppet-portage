# frozen_string_literal: true

require 'spec_helper'
require 'facter/eselect'

describe 'eselect fact specs', type: :fact do
  subject(:fact) { Facter.fact(:eselect) }

  before do
    Facter.clear
    allow(Facter.fact(:os)).to receive(:value).and_return({ 'family' => 'Gentoo' })
  end

  it 'list and show correctly eselect modules' do
    allow(Facter::Core::Execution).to receive(:execute)
      .with('/usr/bin/eselect --brief --color=no modules list --only-names')
      .and_return(%(
help
usage
version
editor
env
modules
news
profile
))

    allow(Facter::Core::Execution).to receive(:execute)
      .with('/usr/bin/eselect --brief --color=no profile help')
      .and_return(%(
Manage the make.profile symlink
Usage: eselect profile <action> <options>

  help                      Display help text
  usage                     Display usage information
  version                   Display version information

  list                      List available profile symlink targets
  set <target>              Set a new profile symlink target
    target                    Target name or number (from 'list' action)
    --force                   Forcibly set the symlink
  show                      Show the current make.profile symlink
))

    allow(Facter::Core::Execution).to receive(:execute)
      .with('/usr/bin/eselect --brief --color=no editor help')
      .and_return(%(
Manage the EDITOR environment variable
Usage: eselect editor <action> <options>

  help                      Display help text
  usage                     Display usage information
  version                   Display version information

  list                      List available targets for the EDITOR variable
  set <target>              Set the EDITOR variable in profile
    target                    Target name or number (from 'list' action)
  show                      Show value of the EDITOR variable in profile
  update                    Update the EDITOR variable if it is unset or invalid
))

    allow(Facter::Core::Execution).to receive(:execute)
      .with('/usr/bin/eselect --brief --color=no profile show')
      .and_return('  default/linux/amd64/23.0/no-multilib')

    allow(Facter::Core::Execution).to receive(:execute)
      .with('/usr/bin/eselect --brief --color=no editor show')
      .and_return('  vim')

    expect(Facter.fact(:eselect).value)
      .to eq({
               'editor' => 'vim',
               'profile' => 'default/linux/amd64/23.0/no-multilib',
             })
  end
end
