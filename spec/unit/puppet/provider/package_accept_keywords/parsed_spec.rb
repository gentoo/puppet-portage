# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:package_accept_keywords).provider(:parsed) do
  describe 'parsing' do
    it 'parses a simple entry' do
      parsed = described_class.parse("app-admin/puppet ~x86\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.first).to include(
        name: 'app-admin/puppet',
        accept_keywords: ['~x86'],
      )
    end

    it 'parses an entry with multiple keywords' do
      parsed = described_class.parse("app-admin/puppet ~x86 -hppa\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.first[:accept_keywords]).to eq(['~x86', '-hppa'])
    end

    it 'parses an entry with a version' do
      parsed = described_class.parse(">=app-admin/puppet-3.0.1 ~amd64\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.first).to include(
        name: 'app-admin/puppet',
        version: '>=3.0.1',
        accept_keywords: ['~amd64'],
      )
    end

    it 'parses an entry with no keywords' do
      parsed = described_class.parse("app-admin/puppet\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.first).to include(
        name: 'app-admin/puppet',
      )
      expect(records.first).not_to have_key(:accept_keywords)
    end

    it 'ignores comment lines as :parsed records' do
      parsed = described_class.parse("# this is a comment\napp-admin/puppet ~x86\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.size).to eq(1)
      expect(records.first[:name]).to eq('app-admin/puppet')
    end

    it 'ignores blank lines as :parsed records' do
      parsed = described_class.parse("\napp-admin/puppet ~x86\n\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.size).to eq(1)
      expect(records.first[:name]).to eq('app-admin/puppet')
    end

    it 'parses multiple entries' do
      parsed = described_class.parse("app-admin/puppet ~x86\napp-misc/foo -hppa\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.size).to eq(2)
      expect(records.map { |p| p[:name] }).to eq(['app-admin/puppet', 'app-misc/foo'])
    end
  end

  describe 'generating a line' do
    it 'writes a simple entry' do
      line = described_class.to_line(
        record_type: :parsed,
        name: 'app-admin/puppet',
        accept_keywords: ['~x86'],
      )
      expect(line.strip).to eq('app-admin/puppet ~x86')
    end

    it 'writes an entry with multiple keywords' do
      line = described_class.to_line(
        record_type: :parsed,
        name: 'app-admin/puppet',
        accept_keywords: ['~x86', '-hppa'],
      )
      expect(line.strip).to eq('app-admin/puppet ~x86 -hppa')
    end

    it 'writes an entry with no keywords' do
      line = described_class.to_line(
        record_type: :parsed,
        name: 'app-admin/puppet',
        accept_keywords: [],
      )
      expect(line.strip).to eq('app-admin/puppet')
    end

    it 'writes an entry with a version' do
      line = described_class.to_line(
        record_type: :parsed,
        name: 'app-admin/puppet',
        version: '>=3.0.1',
        accept_keywords: ['~amd64'],
      )
      expect(line).to eq('>=app-admin/puppet-3.0.1 ~amd64')
    end

    it 'passes through non-:parsed record types to super' do
      line = described_class.to_line(record_type: :comment, line: '# a comment')
      expect(line).to eq('# a comment')
    end
  end

  describe 'round-trip' do
    it 'parses and regenerates an identical line' do
      original = "app-admin/puppet ~x86 -hppa\n"
      records = described_class.parse(original).select { |r| r[:record_type] == :parsed }
      regenerated = described_class.to_line(records.first)
      expect(regenerated.strip).to eq(original.strip)
    end

    it 'parses and regenerates a versioned entry' do
      original = ">=app-admin/puppet-3.0.1 ~amd64\n"
      records = described_class.parse(original).select { |r| r[:record_type] == :parsed }
      regenerated = described_class.to_line(records.first)
      expect(regenerated.strip).to eq(original.strip)
    end
  end

  describe 'instances' do
    let(:resource) do
      Puppet::Type.type(:package_accept_keywords).new(
        name: 'app-admin/puppet',
        accept_keywords: ['~x86'],
        target: '/etc/portage/package.accept_keywords/puppet',
        provider: :parsed,
      )
    end

    it 'creates an instance with the parsed provider' do
      expect(resource.provider).to be_a(described_class)
    end

    it 'exposes the accept_keywords property' do
      expect(resource[:accept_keywords]).to eq(['~x86'])
    end
  end
end
