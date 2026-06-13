# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/package_unmask'

RSpec.describe 'the package_unmask type' do
  it 'loads' do
    expect(Puppet::Type.type(:package_unmask)).not_to be_nil
  end
end
