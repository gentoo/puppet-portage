# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/eselect'

RSpec.describe 'the eselect type' do
  it 'loads' do
    expect(Puppet::Type.type(:eselect)).not_to be_nil
  end
end
