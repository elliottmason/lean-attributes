require 'active_attr'
require 'attrio'
require 'benchmark/ips'
require 'fast_attributes'
require 'lean-attributes'
require 'virtus'

ATTR_NAMES = %i(attr0 attr1 attr2 attr3 attr4 attr5 attr6 attr7 attr8 attr9)

class ActiveAttrIntegers
  include ActiveAttr::MassAssignment
  include ActiveAttr::TypecastedAttributes

  ATTR_NAMES.each do |name|
    attribute name, type: Integer
  end
end

class AttrioIntegers
  include Attrio

  define_attributes do
    ATTR_NAMES.each do |name|
      attr name, Integer
    end
  end

  def initialize(attributes = {})
    attributes.each do |attribute, value|
      public_send("#{attribute}=", value)
    end
  end
end

class FastIntegers
  extend FastAttributes

  define_attributes initialize: true do
    attribute *ATTR_NAMES, Integer
  end
end

class LeanIntegers
  include Lean::Attributes
  include Lean::Attributes::Initializer

  ATTR_NAMES.each do |name|
    attribute name, Integer
  end
end

class VirtusIntegers
  include Virtus.model

  ATTR_NAMES.each do |name|
    attribute name, Integer
  end
end

Benchmark.ips do |x|
  x.config(time: 1, warmup: 1)

  integers = { attr0: 0, attr1: 1, attr2: 2, attr3: 3, attr4: 4, attr5: 5,
               attr6: 6, attr7: 7, attr8: 8, attr9: 9 }
  strings  = { attr0: '0', attr1: '1', attr2: '2', attr3: '3', attr4: '4',
               attr5: '5', attr6: '6', attr7: '7', attr8: '8', attr9: '9' }

  x.report('ActiveAttr: without values                              ') { ActiveAttrIntegers.new }
  x.report('ActiveAttr: integer values for integer attributes       ') { ActiveAttrIntegers.new(integers) }
  x.report('ActiveAttr: string values for integer attributes        ') { ActiveAttrIntegers.new(strings) }

  x.report('Attrio: without values                                  ') { AttrioIntegers.new }
  x.report('Attrio: integer values for integer attributes           ') { AttrioIntegers.new(integers) }
  x.report('Attrio: string values for integer attributes            ') { AttrioIntegers.new(strings) }

  x.report('FastAttributes: without values                          ') { FastIntegers.new }
  x.report('FastAttributes: integer values for integer attributes   ') { FastIntegers.new(integers) }
  x.report('FastAttributes: string values for integer attributes    ') { FastIntegers.new(strings) }

  x.report('Lean::Attributes: without values                        ') { LeanIntegers.new }
  x.report('Lean::Attributes: integer values for integer attributes ') { LeanIntegers.new(integers) }
  x.report('Lean::Attributes: string values for integer attributes  ') { LeanIntegers.new(strings) }

  x.report('Virtus: without values                                  ') { VirtusIntegers.new }
  x.report('Virtus: integer values for integer attributes           ') { VirtusIntegers.new(integers) }
  x.report('Virtus: string values for integer attributes            ') { VirtusIntegers.new(strings) }

  x.compare!
end
