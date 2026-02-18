require 'spec_helper'

describe Puppet::Type.type(:package_keywords).provider(:parsed) do
  before do
    described_class.stubs(:filetype).returns(Puppet::Util::FileType::FileTypeRam)
    described_class.stubs(:filetype=)
    @default_target = described_class.default_target
  end

  it "should have a default target of /etc/portage/package.accept_keywords/default" do
    described_class.default_target.should == "/etc/portage/package.accept_keywords/default"
  end

  describe "when parsing" do

    it "should parse out the package name" do
      line = "app-admin/tree ~amd64"
      described_class.parse_line(line)[:name].should == "app-admin/tree"
    end

    it "should parse out the package name with version" do
      line = ">=app-admin/tree-2.0-r1 ~amd64"
      described_class.parse_line(line)[:name].should == "app-admin/tree"
    end

    it "should parse out the package name with slot" do
      line = "app-admin/tree:2 ~amd64"
      described_class.parse_line(line)[:name].should == "app-admin/tree"
    end

    it "should not raise an error if no keywords are given for a package" do
      line = "app-admin/tree"
      lambda { described_class.parse_line(line) }.should_not raise_error
    end

    it "should parse out a single keywords" do
      line = "app-admin/tree ~amd64"
      described_class.parse_line(line)[:keywords].should == %w{~amd64}
    end

    it "should parse out multiple keywords into an array" do
      line = "app-admin/tree -amd64 ~amd64"
      described_class.parse_line(line)[:keywords].should == %w{-amd64 ~amd64}
    end
  end

  describe "when flushing" do
    before :each do
      @ramfile = Puppet::Util::FileType::FileTypeRam.new(@default_target)
      File.stubs(:exist?).with('/etc/portage/package.accept_keywords').returns(true)
      described_class.any_instance.stubs(:target_object).returns(@ramfile)

      resource = Puppet::Type::Package_keywords.new(:name => 'app-admin/tree', :ensure => :present)
      resource.stubs(:should).with(:target).returns(@default_target)

      @providerinstance = described_class.new(resource)
      @providerinstance.ensure = :present
    end

    after :each do
      described_class.clear
    end

    it "should write an atom name to disk" do
      @providerinstance.flush
      @ramfile.read.should == "app-admin/tree\n"
    end

    it "should write a single keyword to disk" do
      @providerinstance.keywords = "~amd64"
      @providerinstance.flush
      @ramfile.read.should == "app-admin/tree ~amd64\n"
    end

    it "should write an array of keywords to disk" do
      @providerinstance.keywords = %w{~amd64 ~x86}
      @providerinstance.flush
      @ramfile.read.should == "app-admin/tree ~amd64 ~x86\n"
    end
  end
end
