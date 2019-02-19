require 'active_attr'
require 'active_record'
require 'attrio'
require 'benchmark/ips'
require 'dry-struct'
require 'dry-types'
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

ActiveRecord::Base.establish_connection(adapter: 'sqlite3',
                                        database: 'ar_benchmark')
ActiveRecord::Base.connection.drop_table('active_record_integers') rescue false
ActiveRecord::Base.connection.create_table('active_record_integers')

class ActiveRecordIntegers < ActiveRecord::Base
  ATTR_NAMES.each do |name|
    attribute name, :integer
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

module Types
  include Dry::Types.module
end


class DryIntegers < Dry::Struct
  ATTR_NAMES.each do |name|
    attribute name, Types::Coercible::Integer
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

  x.report('ActiveRecord: without values                            ') { ActiveRecordIntegers.new }
  x.report('ActiveRecord: integer values for integer attributes     ') { ActiveRecordIntegers.new(integers) }
  x.report('ActiveRecord: string values for integer attributes      ') { ActiveRecordIntegers.new(strings) }

  x.report('Attrio: without values                                  ') { AttrioIntegers.new }
  x.report('Attrio: integer values for integer attributes           ') { AttrioIntegers.new(integers) }
  x.report('Attrio: string values for integer attributes            ') { AttrioIntegers.new(strings) }

  x.report('dry-types: integer values for integer attributes        ') { DryIntegers.new(integers) }
  x.report('dry-types: string values for integer attributes         ') { DryIntegers.new(strings) }

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
