# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:package_env).provider(:parsed) do
  describe 'parsing' do
    it 'parses a simple entry' do
      parsed = described_class.parse("dev-libs/boost no-distcc\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.first).to include(
        name: 'dev-libs/boost',
        env: ['no-distcc'],
      )
    end

    it 'parses an entry with multiple keywords' do
      parsed = described_class.parse("dev-libs/boost no-distcc single-build-thread\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.first[:env]).to eq(%w[no-distcc single-build-thread])
    end

    it 'parses an entry with a version' do
      parsed = described_class.parse(">=dev-libs/boost-1.90.0 no-distcc\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.first).to include(
        name: 'dev-libs/boost',
        version: '>=1.90.0',
        env: ['no-distcc'],
      )
    end

    it 'parses an entry with no keywords' do
      parsed = described_class.parse("dev-libs/boost\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.first).to include(
        name: 'dev-libs/boost',
      )
      expect(records.first).not_to have_key(:env)
    end

    it 'ignores comment lines as :parsed records' do
      parsed = described_class.parse("# this is a comment\ndev-libs/boost no-distcc\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.size).to eq(1)
      expect(records.first[:name]).to eq('dev-libs/boost')
    end

    it 'ignores blank lines as :parsed records' do
      parsed = described_class.parse("\ndev-libs/boost no-distcc\n\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.size).to eq(1)
      expect(records.first[:name]).to eq('dev-libs/boost')
    end

    it 'parses multiple entries' do
      parsed = described_class.parse("dev-libs/boost no-distcc\napp-misc/foo single-build-thread\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.size).to eq(2)
      expect(records.map { |p| p[:name] }).to eq(['dev-libs/boost', 'app-misc/foo'])
    end
  end

  describe 'generating a line' do
    it 'writes a simple entry' do
      line = described_class.to_line(
        record_type: :parsed,
        name: 'dev-libs/boost',
        env: ['no-distcc'],
      )
      expect(line.strip).to eq('dev-libs/boost no-distcc')
    end

    it 'writes an entry with multiple keywords' do
      line = described_class.to_line(
        record_type: :parsed,
        name: 'dev-libs/boost',
        env: %w[no-distcc single-build-thread],
      )
      expect(line.strip).to eq('dev-libs/boost no-distcc single-build-thread')
    end

    it 'writes an entry with no keywords' do
      line = described_class.to_line(
        record_type: :parsed,
        name: 'dev-libs/boost',
        env: [],
      )
      expect(line.strip).to eq('dev-libs/boost')
    end

    it 'writes an entry with a version' do
      line = described_class.to_line(
        record_type: :parsed,
        name: 'dev-libs/boost',
        version: '>=1.90.0',
        env: ['no-distcc'],
      )
      expect(line).to eq('>=dev-libs/boost-1.90.0 no-distcc')
    end

    it 'passes through non-:parsed record types to super' do
      line = described_class.to_line(record_type: :comment, line: '# a comment')
      expect(line).to eq('# a comment')
    end
  end

  describe 'round-trip' do
    it 'parses and regenerates an identical line' do
      original = "dev-libs/boost no-distcc single-build-thread\n"
      records = described_class.parse(original).select { |r| r[:record_type] == :parsed }
      regenerated = described_class.to_line(records.first)
      expect(regenerated.strip).to eq(original.strip)
    end

    it 'parses and regenerates a versioned entry' do
      original = ">=dev-libs/boost-1.90.0 no-distcc\n"
      records = described_class.parse(original).select { |r| r[:record_type] == :parsed }
      regenerated = described_class.to_line(records.first)
      expect(regenerated.strip).to eq(original.strip)
    end
  end

  describe 'instances' do
    let(:resource) do
      Puppet::Type.type(:package_env).new(
        name: 'dev-libs/boost',
        env: ['no-distcc'],
        target: '/etc/portage/package.env/puppet',
        provider: :parsed,
      )
    end

    it 'creates an instance with the parsed provider' do
      expect(resource.provider).to be_a(described_class)
    end

    it 'exposes the env property' do
      expect(resource[:env]).to eq(['no-distcc'])
    end
  end
end
