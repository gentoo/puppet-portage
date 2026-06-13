# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:package_mask).provider(:parsed) do
  describe 'parsing' do
    it 'parses a simple entry' do
      parsed = described_class.parse("app-admin/chef\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.first).to include(
        name: 'app-admin/chef',
      )
    end

    it 'parses an entry with a version' do
      parsed = described_class.parse(">=app-admin/chef-1.90.0\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.first).to include(
        name: 'app-admin/chef',
        version: '>=1.90.0',
      )
    end

    it 'ignores comment lines as :parsed records' do
      parsed = described_class.parse("# this is a comment\napp-admin/chef\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.size).to eq(1)
      expect(records.first[:name]).to eq('app-admin/chef')
    end

    it 'ignores blank lines as :parsed records' do
      parsed = described_class.parse("\napp-admin/chef\n\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.size).to eq(1)
      expect(records.first[:name]).to eq('app-admin/chef')
    end

    it 'parses multiple entries' do
      parsed = described_class.parse("app-admin/chef\napp-misc/foo\n")
      records = parsed.select { |r| r[:record_type] == :parsed }
      expect(records.size).to eq(2)
      expect(records.map { |p| p[:name] }).to eq(['app-admin/chef', 'app-misc/foo'])
    end
  end

  describe 'generating a line' do
    it 'writes a simple entry' do
      line = described_class.to_line(
        record_type: :parsed,
        name: 'app-admin/chef',
      )
      expect(line.strip).to eq('app-admin/chef')
    end

    it 'writes an entry with a version' do
      line = described_class.to_line(
        record_type: :parsed,
        name: 'app-admin/chef',
        version: '>=1.90.0',
      )
      expect(line).to eq('>=app-admin/chef-1.90.0')
    end

    it 'passes through non-:parsed record types to super' do
      line = described_class.to_line(record_type: :comment, line: '# a comment')
      expect(line).to eq('# a comment')
    end
  end

  describe 'round-trip' do
    it 'parses and regenerates an identical line' do
      original = "app-admin/chef\n"
      records = described_class.parse(original).select { |r| r[:record_type] == :parsed }
      regenerated = described_class.to_line(records.first)
      expect(regenerated.strip).to eq(original.strip)
    end

    it 'parses and regenerates a versioned entry' do
      original = ">=app-admin/chef-1.90.0\n"
      records = described_class.parse(original).select { |r| r[:record_type] == :parsed }
      regenerated = described_class.to_line(records.first)
      expect(regenerated.strip).to eq(original.strip)
    end
  end

  describe 'instances' do
    let(:resource) do
      Puppet::Type.type(:package_mask).new(
        name: 'app-admin/chef',
        target: '/etc/portage/package.mask/puppet',
        provider: :parsed,
      )
    end

    it 'creates an instance with the parsed provider' do
      expect(resource.provider).to be_a(described_class)
    end
  end
end
