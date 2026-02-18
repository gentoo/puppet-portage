require 'spec_helper'

describe Puppet::Type.type(:package_keywords) do
  before do
    @provider = stub 'provider'
    @provider.stubs(:name).returns(:parsed)
    @provider.stubs(:ancestors).returns([Puppet::Provider::ParsedFile])
    @provider.stubs(:default_target).returns("defaulttarget")
    described_class.stubs(:defaultprovider).returns(@provider)
  end

  describe "when validating attributes" do
    params     = [:name]
    properties = [:keywords, :target, :ensure, :version, :slot]

    params.each do |param|
      it "should have the #{param} param" do
        described_class.attrtype(param).should == :param
      end
    end

    properties.each do |property|
      it "should have the #{property} property" do
        described_class.attrtype(property).should == :property
      end
    end
  end

  it "should have name as the namevar" do
    described_class.key_attributes.should == [:name]
  end

  describe "when validating the keywords property" do
    it "should accept a string for keywords" do
      expect { described_class.new(:name => "sys-devel/gcc", :keywords => "~amd64") }.to_not raise_error
    end

    it "should reject keywords with a space" do
      expect { described_class.new(:name => "sys-devel/gcc", :keywords => "~amd 64") }.to raise_error(/cannot contain whitespace/)
    end

    it "should accept an array for keywords" do
      expect { described_class.new(:name => "sys-devel/gcc", :keywords => ["~amd64", "~x86"]) }.to_not raise_error
    end
  end

  describe "when validating the target property" do
    it "should default to the provider's default target" do
      described_class.new(:name => "sys-devel/gcc").should(:target).should == "/etc/portage/package.accept_keywords/defaulttarget"
    end

    it "should munge targets that do not specify a fully qualified path" do
      described_class.new(:name => "sys-devel/gcc", :target => "gcc").should(:target).should == "/etc/portage/package.accept_keywords/gcc"
    end

    it "should not munge fully qualified targets" do
      described_class.new(:name => "sys-devel/gcc", :target => "/tmp/gcc").should(:target).should == "/tmp/gcc"
    end
  end

  describe "when validating the keywords property" do
    it "should default to an empty list" do
      described_class.new(:name => "sys-devel/gcc").should(:keywords).should == []
    end

    it "should properly handle nested arrays" do
      described_class.new(:name => "sys-devel/gcc", :keywords => ["foo",["bar"]]).property(:keywords).insync?(["foo","bar"]).should eq true
    end
  end
end
