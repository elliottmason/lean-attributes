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
      attr_reader :name

      # @!attribute [r] name
      #   @return [Symbol] name of the {Attribute Attribute}

      # Description of method
      #
      # @param [Hash] options = {} describe options = {}
      # @return [Attribute] description of returned object
      #
      # @see Lean::Attributes::ClassMethods#attribute
      def initialize(options = {})
        @default  = options[:default]
        @name     = options[:name].to_sym
        @type     = options[:type].to_s.to_sym
      end

      # Generates a method definition as a String with the name
      # `coerce\_<attribute>\_to\_<type>` that calls another generated method
      # with the name `coerce\_to\_<type>`. This method gets appended to the
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

      # Generates a method with a name `coerce\_to\_<type>`, or
      # `coerce\_<attribute>\_to\_<type>` if an argument is provided.
      #
      # @param [#to_s] from = nil describe from = nil
      # @return [String] description of returned object
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
      #   class Post
      #     include Lean::Attributes
      #
      #     attribute :replies_count, Integer
      #
      #     # generated method
      #     def replies_count=(value)
      #       value = coerce_replies_count_to_integer(value) unless value.is_a?(Integer)
      #       @replies_count = value
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
