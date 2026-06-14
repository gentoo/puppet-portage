# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/package_mask'

RSpec.describe 'the package_mask type' do
  it 'loads' do
    expect(Puppet::Type.type(:package_mask)).not_to be_nil
  end
end
