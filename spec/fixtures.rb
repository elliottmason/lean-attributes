require 'bigdecimal'
require 'time'

class Medium
  include Lean::Attributes::Basic

  attribute :authors,       Array
  attribute :edition,       String
  attribute :finished,      DateTime
  attribute :price,         BigDecimal
  attribute :public_domain, :Boolean, default: false
  attribute :published,     Date
  attribute :rate,          Float
  attribute :sold,          Time
  attribute :title,         String
end

class Book < Medium
  attribute :format,  Symbol, default: :hardcover
  attribute :pages,   Integer
end

class Author
  include Lean::Attributes

  attribute :age,  Integer
  attribute :name, String
end

class PageNumber
  include Lean::Attributes::Basic

  attribute :value, Integer

  def initialize(value)
    self.value = value
  end

  def ==(other)
    case other
    when self.class then value == other.value
    when Integer then value == other
    when String then value == other.to_i
    end
  end

  def inspect
    @value.inspect
  end

  def value=(value)
    @value = coerce_value(value)
    @value = 1 if @value < 1
    @value
  end
end

class ReadingProgress
  include Lean::Attributes

  attribute :date,        Time,       default: ->{ Time.now }
  attribute :page,        PageNumber, default: PageNumber.new(1)
  attribute :percentage,  Float,      default: 0.0
  attribute :status,      Symbol,     default: :unread
end
