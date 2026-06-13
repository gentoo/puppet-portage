# frozen_string_literal: true

Puppet::Type.newtype(:webapp) do
  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    desc 'The name of the webapp.'
  end

  newproperty(:appname) do
    desc 'The name of the package to install'
  end

  newproperty(:appversion) do
    desc 'The version of the package to install'
  end

  newparam(:server) do
    desc 'The web server used to access the webapp.'
  end

  newparam(:user) do
    desc 'The user who owns installed configuration files.'
  end

  newparam(:group) do
    desc 'The group which owns installed configuration files.'
  end

  newparam(:soft) do
    desc 'Whether to use softlinks.'
    defaultto :no
    newvalues(:yes, :no)
  end

  newproperty(:secure) do
    desc 'Whether to use htdocs-secure instead of htdocs.'
    defaultto :no
    newvalues(:yes, :no)
  end
end
