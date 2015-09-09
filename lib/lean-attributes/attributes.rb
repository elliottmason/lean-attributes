require 'lean-attributes/attributes/class_methods'
require 'lean-attributes/attributes/coercion_helpers'
require 'lean-attributes/attributes/initializer'

module Lean
  module Attributes
    def self.included(base)
      base.class_eval do
        include Basic
        include CoercionHelpers
        include Initializer
      end
    end

    module Basic
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end
    end
  end
end
