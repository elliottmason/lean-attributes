require 'lean-attributes/attributes/attribute'

module Lean
  module Attributes
    module ClassMethods
      def attribute(name, type, options = {})
        attribute = Attribute.new(default_value: options[:default],
                                  name: name, parent_class: self, type: type)

        class_eval(attribute.coercion_method, __FILE__, __LINE__ + 1) \
          if attribute.coercible?
        class_eval(attribute.getter_method,   __FILE__, __LINE__ + 1)
        class_eval(attribute.setter_method,   __FILE__, __LINE__ + 1)

        attribute
      end
    end
  end
end
