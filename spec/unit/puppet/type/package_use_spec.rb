# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/package_use'

RSpec.describe 'the package_use type' do
  it 'loads' do
    expect(Puppet::Type.type(:package_use)).not_to be_nil
  end
end
