module Lean
  module Attributes
    # Represents a generated coercion method for a specific type, which is
    # subsequently injected into the class calling {ClassMethods#attribute}
    #
    # @since 0.4.0
    # @api private
    #
    # @see ClassMethods#attribute
    class TypeCoercionMethod
      # Super basic coercion logic for a handful of common types
      METHOD_BODIES = {
        Array:      'Array(value)',
        BigDecimal: 'BigDecimal(value, 0)',
        Boolean:    'value ? true : false',
        Date:       'Date.parse(value)',
        DateTime:   'DateTime.parse(value)',
        Float:      'value.to_f',
        Integer:    'value.to_i',
        String:     'value.to_s',
        Symbol:     'value.to_sym',
        Time:       'value.is_a?(Time) ? value : Time.parse(value)'
      }.freeze

      NAMESPACE_SEPARATOR = '::'.freeze

      UNDERSCORE_DIVISION_TARGET = '\1_\2'.freeze

      UNDERSCORE_SEPARATOR = '__'.freeze

      # @example
      #   TypeCoercionMethod.method_name(Integer) => "coerce_integer_attribute"
      #
      # @return [String]
      #
      # @see .underscore_class_name
      def self.method_name(type)
        'coerce_' + underscore_class_name(type) + '_attribute'
      end

      #
      # @example
      #   TypeCoercionMethod.underscore_class_name(Book::PageNumber) =>
      #     "book__page_number"
      #
      # @return [String] class name transformed to be used as a method name
      #
      # @note This code was stolen from Hanami::Utils
      def self.underscore_class_name(input)
        string = ::String.new(input.to_s)
        string.gsub!(NAMESPACE_SEPARATOR, UNDERSCORE_SEPARATOR)
        string.gsub!(/([A-Z\d]+)([A-Z][a-z])/, UNDERSCORE_DIVISION_TARGET)
        string.gsub!(/([a-z\d])([A-Z])/, UNDERSCORE_DIVISION_TARGET)
        string.gsub!(/[[:space:]]|\-/, UNDERSCORE_DIVISION_TARGET)
        string.downcase
      end

      def initialize(type)
        @type = type.to_s.to_sym
      end

      # Uses a default method body to do basic coercion for a handful of known
      # types, or generates a generic `<AttributeClass>.new` conditional for
      # other types
      #
      # @return [String] the coercion method's inner body
      #
      # @see METHOD_BODIES
      def body
        if (method_body = METHOD_BODIES[@type])
          return "#{method_body} unless value.nil?"
        end

        <<-RUBY.chomp
          return if value.nil?
          return #{@type}.new(value) if !value.is_a?(#{@type})
          value
        RUBY
      end

      # @return [String] the full coercion method definition
      #
      # @see #body
      # @see #name
      def definition
        <<-RUBY.chomp
          def #{name}(value)
            #{body}
          end
        RUBY
      end

      # @return [String] the name to be used for the coercion method
      #
      # @see .method_name
      def name
        self.class.method_name(@type)
      end
    end
  end
end
