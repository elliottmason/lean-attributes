module Lean
  module Attributes
    class Attribute
      attr_reader :name

      def initialize(options = {})
        @default  = options[:default]
        @name     = options[:name].to_sym
        @type     = options[:type].to_s.to_sym
      end

      def coercion_method
        <<-EOS
          def #{coercion_method_name(name)}(value)
            #{coercion_method_name}(value)
          end
        EOS
      end

      def coercion_method_name(from = nil)
        ['coerce', from, 'to', @type.to_s.downcase].compact.join('_')
      end

      def default
        if @default.is_a?(Symbol) && @type != :Symbol
          return "send(:#{@default})"
        end

        @default.inspect
      end

      def getter_method
        return getter_method_with_default unless @default.nil?

        "attr_reader :#{@name}"
      end

      def getter_method_with_default
        <<-EOS
          def #{name}
            @#{name} ||= #{default}
          end
        EOS
      end

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
