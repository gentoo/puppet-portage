# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/package_env'

RSpec.describe 'the package_env type' do
  it 'loads' do
    expect(Puppet::Type.type(:package_env)).not_to be_nil
  end
end
