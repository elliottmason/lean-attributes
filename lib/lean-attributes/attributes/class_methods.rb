require 'lean-attributes/attributes/attribute'

module Lean
  module Attributes
    module ClassMethods
      def attribute(name, type, options = {})
        attribute = Attribute.new(
          default:  options[:default],
          name:     name,
          type:     type
        )

        defined_attributes << attribute.name

        class_eval(attribute.coercion_method, __FILE__, __LINE__ + 1)
        class_eval(attribute.getter_method,   __FILE__, __LINE__ + 1)
        class_eval(attribute.setter_method,   __FILE__, __LINE__ + 1)

        attribute
      end

      def defined_attributes
        return @defined_attributes if @defined_attributes

        @defined_attributes = if superclass.respond_to?(:defined_attributes)
                                superclass.defined_attributes.clone
                              else
                                []
                              end
      end
    end
  end
end
