module Lean
  module Attributes
    # Incredibly straightforward methods that coerce some types into other
    # common types. You may find that you need to override these methods,
    # depending on your use case.
    #
    # @since 0.1.0
    module CoercionHelpers
      # Coerce a value to an Array
      #
      # @param [Object] value
      # @return [Array] coerced value
      def coerce_to_array(value)
        Array(value) unless value.nil?
      end

      # Coerce a value to a BigDecimal
      #
      # @param [Object] value value to coerce
      # @return [BigDecimal] coerced value
      def coerce_to_bigdecimal(value)
        BigDecimal.new(value, 0) unless value.nil?
      end

      # Coerce a value to a Date
      #
      # @param [Object] value value to coerce
      # @return [Date] coerced value
      def coerce_to_date(value)
        Date.parse(value) unless value.nil?
      end

      # Coerce a value to a DateTime
      #
      # @param [Object] value value to coerce
      # @return [DateTime] coerced value
      def coerce_to_datetime(value)
        DateTime.parse(value) unless value.nil?
      end

      # Coerce a value to an Integer
      #
      # @param [Object] value value to coerce
      # @return [Fixnum] coerced value
      def coerce_to_integer(value)
        value.to_i unless value.nil?
      end

      # Coerce a value to a String
      #
      # @param [Object] value value to coerce
      # @return [String] coerced value
      def coerce_to_string(value)
        value.to_s unless value.nil?
      end

      # Coerce a value to a Symbol
      #
      # @param [Object] value value to coerce
      # @return [Symbol] coerced value
      def coerce_to_symbol(value)
        value.to_sym unless value.nil?
      end

      # Coerce a value to a Time
      #
      # @param [Object] value value to coerce
      # @return [Time] coerced value
      def coerce_to_time(value)
        Time.parse(value) unless value.nil?
      end
    end
  end
end
