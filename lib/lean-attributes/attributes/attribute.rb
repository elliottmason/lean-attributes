module Lean
  module Attributes
    class Attribute
      attr_reader :name

      def initialize(options = {})
        @default_value  = options[:default_value]
        @name           = options[:name]
        @parent_class   = options[:parent_class]
        @type           = options[:type].to_s
      end

      def coercion_method
        <<-EOS
          def #{coercion_method_name(name)}(value)
            #{coercion_method_name}(value)
          end
        EOS
      end

      def coercible?
        return @coercible unless @coercible.nil?

        @coercible = @parent_class.method_defined?(coercion_method_name)
      end

      def coercion_method_name(from = nil)
        ['coerce', from, 'to', @type.downcase].compact.join('_')
      end

      def default_value
        return "send(:#{@default_value})" if @default_value.is_a?(Symbol) &&
                                             !@type.is_a?(Symbol)

        @default_value.inspect
      end

      def getter_method
        return getter_method_with_default unless @default_value.nil?

        "attr_reader :#{@name}"
      end

      def getter_method_with_default
        <<-EOS
          def #{name}
            @#{name} ||= #{default_value}
          end
        EOS
      end

      def name
        @name.to_sym
      end

      def setter_method
        <<-EOS
          def #{name}=(value)
            #{setter_method_coercion}
            @#{name} = value
          end
        EOS
      end

      def setter_method_coercion
        return unless coercible?

        <<-EOS
          value = #{coercion_method_name}(value) unless value.is_a?(#{@type})
        EOS
      end

      # def type_coercion_method_name
      #   @type_coercion_method_name ||= :"coerce_to_#{@type.downcase}"
      # end
    end
  end
end
