# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/package_accept_keywords'

RSpec.describe 'the package_accept_keywords type' do
  it 'loads' do
    expect(Puppet::Type.type(:package_accept_keywords)).not_to be_nil
  end
end
