require 'lean-attributes/attributes/attribute'

module Lean
  module Attributes
    # Methods that extend classes that include {Lean::Attributes}
    #
    # @since 0.0.1
    # @api public
    module ClassMethods
      # Injects the generated coercion, getter, and setter instance methods from
      # the provided attribute into the class.
      #
      # @param [Attribute] attribute
      #
      # @since 0.4.0
      # @api private
      def add_attribute_methods(attribute)
        class_eval(attribute.coercion_method, __FILE__, __LINE__ + 1)
        class_eval(attribute.getter_method,   __FILE__, __LINE__ + 1)
        class_eval(attribute.setter_method,   __FILE__, __LINE__ + 1)
      end

      # If missing, injects a generated coercion method named after the type,
      # which is used by attributes of said type
      #
      # @param [Symbol] type
      #
      # @since 0.4.0
      # @api private
      #
      # @see Lean::TypeCoercionMethod
      def add_type_coercion_method(type)
        return if defined_attribute_types.include?(type)

        type_coercion_method = TypeCoercionMethod.new(type)
        class_eval(type_coercion_method.definition, __FILE__, __LINE__ + 1)

        defined_attribute_types << type
      end

      # Defines a new attribute. Adds getter and setter methods to the class.
      #
      # @param [Symbol] name attribute name that will be used as an attribute
      #                      reader and writer
      # @param [Class,String,Symbol] type class or class name of the attribute
      # @param [Hash] options
      # @option options [Object] :default default value or Proc to call
      # @return [Attribute] configured Attribute
      #
      # @see #add_attribute_methods
      # @see #add_type_coercion_method
      # @see #attribute_defaults
      # @see #defined_attributes
      def attribute(name, type, options = {})
        attribute = Attribute.new(
          default:  options[:default],
          name:     name,
          type:     type
        )

        defined_attributes << attribute.name
        attribute_defaults[name] = attribute.default

        add_attribute_methods(attribute)
        add_type_coercion_method(attribute.type)

        attribute
      end

      # @return [Hash] `{ attribute_name: <default_value> }`
      #
      # @since 0.4.0
      # @api private
      def attribute_defaults
        @_attribute_defaults ||= {}
      end

      # @return [Array<Symbol>] unique types that have been used by defined
      #                         attributes
      #
      # @since 0.4.0
      # @api private
      def defined_attribute_types
        return @_defined_attribute_types if @_defined_attribute_types

        @_defined_attribute_types =
          if superclass.respond_to?(:defined_attribute_types)
            superclass.defined_attribute_types.clone
          else
            []
          end
      end

      # @return [Array<Symbol>] names of defined attributes
      #
      # @since 0.2.0
      # @api private
      def defined_attributes
        return @_defined_attributes if @_defined_attributes

        @_defined_attributes =
          if superclass.respond_to?(:defined_attributes)
            superclass.defined_attributes.clone
          else
            []
          end
      end
    end
  end
end
