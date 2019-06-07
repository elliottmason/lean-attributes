module Lean
  module Attributes
    # Represents an attribute defined by
    # {ClassMethods#attribute}
    #
    # @since 0.0.1
    # @api private
    #
    # @see ClassMethods#attribute
    class Attribute
      # @return [Object] default value for this Attribute
      attr_reader :default

      # @return [Symbol] name of the Attribute
      attr_reader :name

      # @return [Symbol] class name of the Attribute type
      attr_reader :type

      # Description of method
      #
      # @param [Hash] options = {} describe options = {}
      # @option options [Object] :default default value or a Proc to `call` to
      #                                   generate one
      # @option options [#to_sym] :name attribute name
      # @option options [#to_s] :type class or class name that the attribute
      #   will be
      # @return [Attribute] description of returned object
      #
      # @since 0.4.0
      #
      # @see Lean::Attributes::ClassMethods#attribute
      def initialize(options = {})
        @default  = options[:default]
        @name     = options[:name].to_sym
        @type     = options[:type].to_s.to_sym
      end

      # Generates a method definition as a String with the name
      # `coerce_<attribute>`.
      #
      # @example
      #   class Post
      #     include Lean::Attributes
      #
      #     attribute :author, String
      #     attribute :parent, Post
      #
      #     # generated_methods:
      #     # def coerce_author(value)
      #     #   coerce_string(value)
      #     # end
      #
      #     # def coerce_parent(value)
      #     #   coerce_post(value)
      #     # end
      #   end
      #
      # @return [String] method definition
      #
      # @see #coercion_method_name
      # @see TypeCoercionMethod
      def coercion_method
        <<-RUBY
          def #{coercion_method_name}(value)
            #{TypeCoercionMethod.method_name(@type)}(value)
          end
        RUBY
      end

      # Generates a method with a name `coerce_<attribute>`.
      #
      # @return [String] method name
      #
      # @see #coercion_method
      def coercion_method_name
        "coerce_#{name}"
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
      #     # generated attr_reader:
      #     # attr_reader :author
      #
      #     # generated getter with default
      #     # def replies_count
      #     #  @replies_count ||= self.class.attribute_defaults[:replies_count]
      #     # end
      #   end
      #
      # @return [String] `attr_reader` or getter method definition to inject
      #                  into the class defining this attribute
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
      #     # generated methods:
      #     # def created_at
      #     #   @first_name ||= send(:default_created_at)
      #     # end
      #
      #     # def replies_count
      #     #   @replies_count ||= 0
      #     # end
      #   end
      #
      # @return [String] getter method definition that sets default when the
      #                  attribute is value is nil
      #
      # @see #default
      # @see #getter_method
      # @see getter_method_with_default_body
      def getter_method_with_default
        <<-RUBY
          def #{name}
            #{getter_method_with_default_body}
          end
        RUBY
      end

      # Returns a method body that sets the attribute to the configured default
      # value, or the value resultant from `call`ing the default value Proc
      #
      # @return [String] the body for the getter method
      #
      # @since 0.4.0
      #
      # @see #getter_method
      # @see #getter_method_with_default
      def getter_method_with_default_body
        case @default
        when Proc
          %[@#{name} ||= self.class.attribute_defaults[:#{name}].call]
        else
          %[@#{name} ||= self.class.attribute_defaults[:#{name}]]
        end
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
      #     # generated method:
      #     # def pages=(value)
      #     #   @pages = coerce_pages(value)
      #     # end
      #   end
      #
      # @return [String] method definition that sets the attribute to the given
      #                  value after coercion
      #
      # @see #coercion_method_name
      def setter_method
        <<-EOS
          def #{name}=(value)
            @#{name} = #{coercion_method_name}(value)
          end
        EOS
      end
    end
  end
end
