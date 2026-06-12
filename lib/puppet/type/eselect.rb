# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'eselect',
  docs: <<~EOS,
    @summary Manages eselect modules on Gentoo systems.
    @example
      eselect { 'editor':
        set => 'vim',
      }

    This type provides Puppet with the capability to manage `eselect`
    modules, allowing you to set the active value for a given module
    (e.g. `editor`, `profile`, `java-vm`, `php::cli`).
  EOS
  features: [],
  attributes: {
    name: {
      type: 'String',
      desc: 'The name of the eselect module to manage (e.g. `editor`, `profile`, `java-vm`).',
      behaviour: :namevar,
    },
    set: {
      type: 'String',
      desc: 'The value to set as active for this eselect module.',
    },
  },
)
