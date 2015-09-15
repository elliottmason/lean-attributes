require 'lean-attributes/attributes/attribute'

module Lean
  module Attributes
    # Methods that extend classes that include {Lean::Attributes}
    #
    # @since 0.0.1
    # @api public
    module ClassMethods
      # Defines a new attribute. Adds getter and setter methods to the class.
      #
      # @param [Symbol] name describe name
      # @param [Class,String,Symbol] type describe type
      # @param [Hash] options
      # @option options [Object] :default default value or method name to call
      #   as a Symbol
      # @return [Attribute] configured Attribute
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

      # @return [Array<Symbol>] names of defined attributes
      #
      # @since 0.1.1
      # @api private
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
