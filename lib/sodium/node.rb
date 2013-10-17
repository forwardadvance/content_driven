require_relative "support"
require_relative "dsl"
require_relative "node_list"
require_relative "routes"
require 'active_support/core_ext/string'

module Sodium

  # Sodium defines a tree of content. Node is the base class.
  # A Node has a parent and zero or more children
  class Node
    attr_accessor :parent, :children, :url, :title, :date

    extend Sodium::DSL
    include Sodium::Routes

    def self.inherited(subclass)
      define_dsl_for(subclass)
    end

    def initialize &block
      self.children = NodeList.new
      if block_given?
        self.instance_eval &block
      end
    end

    def add_child key, node = nil
      if key.is_a? Node
        node, key = key, (children.keys.length + 1).to_sym
      end
      node.parent = self
      node.url = key
      children[key] = node
    end

    def root?
      self.parent.nil?
    end

    def to_sym
      if root?
        return :root
      else
        return self.url.to_sym
      end
    end

  end
end