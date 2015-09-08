require 'lean-attributes/attributes/class_methods'
require 'lean-attributes/attributes/coercion'
require 'lean-attributes/attributes/initializer'

module Lean
  module Attributes
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include Coercion
      end
    end
  end
end
