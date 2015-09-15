module Lean
  module Attributes
    # Adds an `#initialize` method that sets attribute values based on
    # Hash keys-values
    #
    # @since 0.0.1
    module Initializer
      # Description of method
      #
      # @param [Hash] attributes = {} attributes with which to set on the
      # instance
      # @return [Object]
      #
      # @since 0.0.1
      # @api public
      def initialize(attributes = {})
        attributes.each do |name, value|
          send(:"#{name}=", value)
        end
      end
    end
  end
end
