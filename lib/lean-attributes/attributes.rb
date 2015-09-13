require 'lean-attributes/attributes/class_methods'
require 'lean-attributes/attributes/coercion_helpers'
require 'lean-attributes/attributes/initializer'

module Lean
  module Attributes
    module Basic
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      def attributes
        @attributes ||=
          self.class.defined_attributes.inject({}) do |memo, attribute|
            memo[attribute] = send(attribute)
            memo
          end
      end
    end

    def self.included(base)
      base.class_eval do
        include Basic
        include CoercionHelpers
        include Initializer
      end
    end
  end
end
