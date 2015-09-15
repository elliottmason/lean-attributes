module Lean
  module Attributes
    # Adds an `#initialize` method that sets attribute values based on
    # Hash keys-values
    #
    # @since 0.0.1
    # @api public
    module Initializer
      # Assigns Hash values to attributes based on key names
      #
      # @param [Hash] attributes
      # @return [Object] instance of inclusive class with attributes set
      def initialize(attributes = {})
        attributes.each do |name, value|
          send(:"#{name}=", value)
        end
      end
    end
  end
end
