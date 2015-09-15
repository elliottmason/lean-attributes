require 'lean-attributes/attributes/class_methods'
require 'lean-attributes/attributes/coercion_helpers'
require 'lean-attributes/attributes/initializer'

module Lean
  # Allows one to define typed, coercible attributes on Ruby classes with
  # the {Lean::Attributes::ClassMethods#attribute attribute} method.
  #
  # @since 0.0.1
  # @api public
  #
  # @see Lean::Attributes::ClassMethods#attribute
  module Attributes
    # Includes basic methods for defining attributes without polluting the
    # inclusive class with coercion or initialization methods. You may mean to
    # use {Lean::Attributes}.
    #
    # @since 0.1.0
    #
    # @see Lean::Attributes
    # @see Lean::Attributes::ClassMethods
    module Basic
      # `include Lean::Attributes::Basic` adds only `attribute` definition to
      # your classes. This means initialization with a hash and coerction of
      # attributes is not provided.
      #
      # @since 0.1.0
      # @api private
      #
      # @see ClassMethods
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      # Returns a hash containing defined attribute names and their values.
      #
      # @return [Hash] defined attributes and their values
      #
      # @since 0.1.1
      # @api public
      def attributes
        @attributes ||=
          self.class.defined_attributes.each_with_object({}) do |attr, memo|
            memo[attr] = send(attr)
          end
      end
    end

    # `include Lean::Attributes` will add {Basic} functionality, in addition
    # to {CoercionHelpers} and {Initializer}
    #
    # @since 0.1.0
    # @api private
    #
    # @see Basic
    # @see ClassMethods
    # @see CoercionHelpers
    # @see Initializer
    def self.included(base)
      base.class_eval do
        include Basic
        include CoercionHelpers
        include Initializer
      end
    end
  end
end
