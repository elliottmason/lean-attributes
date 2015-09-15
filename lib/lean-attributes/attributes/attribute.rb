module Lean
  module Attributes
    # Represents an attribute defined by
    # {Lean::Attributes::ClassMethods#attribute}
    #
    # @since 0.0.1
    # @api private
    #
    # @see Lean::Attributes::ClassMethods#attribute
    class Attribute
      # @return [Symbol] name of the Attribute
      attr_reader :name

      # Description of method
      #
      # @param [Hash] options = {} describe options = {}
      # @option options [Object] :default default value or method name as a
      #   Symbol
      # @option options [#to_sym] :name attribute name
      # @option options [#to_s] :type class or class name that the attribute
      #   will be
      # @return [Attribute] description of returned object
      #
      # @see Lean::Attributes::ClassMethods#attribute
      def initialize(options = {})
        @default  = options[:default]
        @name     = options[:name].to_sym
        @type     = options[:type].to_s.to_sym
      end

      # Generates a method definition as a String with the name
      # `coerce_<attribute>_to_<type>` that calls another generated method
      # with the name `coerce_to_<type>`. This method gets appended to the
      # class that defined this {Attribute Attribute}.
      #
      # @return [String] method definition
      #
      # @see #coercion_method_name
      def coercion_method
        <<-EOS
          def #{coercion_method_name(name)}(value)
            #{coercion_method_name}(value)
          end
        EOS
      end

      # Generates a method with a name `coerce_to_<type>`, or
      # `coerce_<attribute>_to_<type>` if an argument is provided.
      #
      # @param [#to_s] from {Lean::Attributes::Attribute#name name} of the
      #   attribute being coerced
      # @return [String] method name
      #
      # @see #coercion_method
      def coercion_method_name(from = nil)
        ['coerce', from, 'to', @type.to_s.downcase].compact.join('_')
      end

      # If the configured default is a Symbol but the intended type for this
      # attribute is anything but, interpret the default as a method name to
      # which we will `send`. Otherwise, just use the configured default as a
      # String.
      #
      # @return [Object] configured default
      #
      # @since 0.1.0
      #
      # @see #getter_method_with_default
      def default
        if @default.is_a?(Symbol) && @type != :Symbol
          return "send(:#{@default})"
        end

        @default.inspect
      end

      # Generates a getter method definition if the Attribute has a default,
      # or we just use the straightforward `attr_reader :attribute_name`.
      #
      # @example
      #   class Post
      #     include Lean::Attributes
      #
      #     attribute :author,        String
      #     attribute :replies_count, Integer, default: 0
      #
      #     # generated attr_reader
      #     attr_reader :author
      #
      #     # generated getter with default
      #     def replies_count
      #       @replies_count ||= 0
      #     end
      #   end
      #
      # @return [String] description of returned object
      #
      # @see #getter_method_with_default
      def getter_method
        return getter_method_with_default unless @default.nil?

        "attr_reader :#{@name}"
      end

      # Generates a getter method definition that lazily sets a default.
      #
      # @example
      #   class Post
      #     include Lean::Attributes
      #
      #     attribute :created_at,    Time,     default: :default_created_at
      #     attribute :replies_count, Integer,  default: 0
      #
      #     # generated methods
      #     def created_at
      #       @first_name ||= send(:default_created_at)
      #     end
      #
      #     def replies_count
      #       @replies_count ||= 0
      #     end
      #   end
      #
      # @return [String] method definition that sets default
      #
      # @see #default
      # @see #getter_method
      def getter_method_with_default
        <<-EOS
          def #{name}
            @#{name} ||= #{default}
          end
        EOS
      end

      # Generates a setter method definition that coerces values to the
      # configured type if necessary.
      #
      # @example
      #   class Book
      #     include Lean::Attributes
      #
      #     attribute :pages, Integer
      #
      #     # generated method
      #     def pages=(value)
      #       value = coerce_pages_to_integer(value) unless value.is_a?(Integer)
      #       @pages = value
      #     end
      #   end
      #
      # @return [String] method definition
      def setter_method
        <<-EOS
          def #{name}=(value)
            value = #{coercion_method_name}(value) unless value.is_a?(#{@type})
            @#{name} = value
          end
        EOS
      end
    end
  end
end
