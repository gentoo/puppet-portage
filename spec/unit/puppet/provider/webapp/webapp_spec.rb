# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:webapp).provider(:webapp) do
  let(:resource) do
    Puppet::Type.type(:webapp).new(
      name: 'localhost::/',
      ensure: :present,
      appname: 'foo',
      appversion: '1.0',
      provider: described_class.name,
    )
  end
  let(:provider) { resource.provider }

  describe '.instances' do
    before do
      allow(described_class).to receive(:webapp_config)
        .with('--list-installs')
        .and_return("/var/www/localhost/htdocs/foo\n/var/www/example.com/htdocs-secure/bar\n")
      allow(described_class).to receive(:webapp_config)
        .with(array_including('--show-installed'))
        .and_return('foo 1.0')
    end

    it 'parses installed webapps' do
      instances = described_class.instances
      expect(instances.map { |i| i.get(:name) }).to contain_exactly('localhost::/foo', 'example.com::/bar')
      expect(instances.map { |i| i.get(:secure) }).to contain_exactly(:no, :yes)
      expect(instances.first.get(:ensure)).to eq(:present)
      expect(instances.first.get(:appname)).to eq('foo')
      expect(instances.first.get(:appversion)).to eq('1.0')
    end
  end

  describe '.prefetch' do
    it 'assigns matching provider to resource' do
      match = described_class.new(name: 'localhost::/', ensure: :present)
      allow(described_class).to receive(:instances).and_return([match])

      resources = { 'localhost::/' => resource }
      described_class.prefetch(resources)

      expect(resources['localhost::/'].provider).to eq(match)
    end
  end

  describe '#exists?' do
    it 'reflects ensure value' do
      provider.set(ensure: :present)
      expect(provider.exists?).to be true

      provider.set(ensure: :absent)
      expect(provider.exists?).to be false
    end
  end

  describe '#create' do
    it 'calls webapp-config --install' do
      allow(provider).to receive(:webapp_config)
      provider.create
      expect(provider).to have_received(:webapp_config).with(array_including('--install', '--appname', 'foo', '--appversion', '1.0'))
    end
  end

  describe '#destroy' do
    it 'calls webapp-config --clean' do
      allow(provider).to receive(:webapp_config)
      provider.destroy
      expect(provider).to have_received(:webapp_config).with(array_including('--clean', '--appname', 'foo', '--appversion', '1.0'))
    end
  end
end
