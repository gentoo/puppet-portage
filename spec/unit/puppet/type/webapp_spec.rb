# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/webapp'

RSpec.describe 'the webapp type' do
  it 'loads' do
    expect(Puppet::Type.type(:webapp)).not_to be_nil
  end
end
