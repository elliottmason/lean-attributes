module Lean
  module Attributes
    module CoercionHelpers
      def coerce_to_array(value)
        Array(value) unless value.nil?
      end

      def coerce_to_bigdecimal(value)
        BigDecimal.new(value, 0) unless value.nil?
      end

      def coerce_to_date(value)
        Date.parse(value) unless value.nil?
      end

      def coerce_to_datetime(value)
        DateTime.parse(value) unless value.nil?
      end

      def coerce_to_integer(value)
        value.to_i unless value.nil?
      end

      def coerce_to_string(value)
        value.to_s unless value.nil?
      end

      def coerce_to_symbol(value)
        value.to_sym unless value.nil?
      end

      def coerce_to_time(value)
        Time.new(value) unless value.nil?
      end
    end
  end
end
