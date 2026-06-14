# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:eselect).provider(:eselect) do
  let(:resource) do
    Puppet::Type.type(:eselect).new(name: 'editor', set: 'nano')
  end

  before do
    allow(Facter).to receive(:value).with('os.family').and_return('Gentoo')
    allow(Facter).to receive(:value)
      .with(:eselect)
      .and_return({
                    'editor' => 'vim',
                    'profile' => 'default/linux/amd64/23.0/no-multilib',
                  })
  end

  describe '.instances' do
    it 'returns the list of module names form the eselect fact' do
      expect(described_class.instances).to eq(%w[editor profile])
    end
  end

  describe '#get' do
    subject(:provider) { described_class.new(resource) }

    it 'runs eselect with the get flag and parse the output' do
      allow(described_class).to receive(:eselect)
        .with(['--brief', '--color=no', 'editor', 'show'])
        .and_return("vim\n")

      expect(provider.set).to eq('vim')
    end
  end

  describe '#set=' do
    subject(:provider) { described_class.new(resource) }

    let(:resource) { Puppet::Type.type(:eselect).new(name: 'editor', set: 'nano') }

    it 'runs eselect to set, then get, and parses the output' do
      allow(described_class).to receive(:eselect)
        .with(['--brief', '--color=no', 'editor', 'set', 'nano'])

      allow(described_class).to receive(:eselect)
        .with(['--brief', '--color=no', 'editor', 'show'])
        .and_return("nano\n")

      provider.set = 'nano'

      expect(described_class).to have_received(:eselect)
        .with(['--brief', '--color=no', 'editor', 'set', 'nano'])

      expect(described_class).to have_received(:eselect)
        .with(['--brief', '--color=no', 'editor', 'show'])
    end
  end
end
