require 'bigdecimal'

class Medium
  include Lean::Attributes::Basic

  attribute :authors,   Array
  attribute :edition,   String
  attribute :finished,  DateTime
  attribute :price,     BigDecimal
  attribute :published, Date
  attribute :rate,      Float
  attribute :sold,      Time
  attribute :title,     String
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
  def initialize(value)
    @value = value
  end

  def value=(value)
    value = value.to_i
    value = 1 if value < 1
    @value = value
  end

  def inspect
    @value.inspect
  end
end

class ReadingProgress
  include Lean::Attributes

  attribute :date,        Time,       default: :time_now
  attribute :page,        PageNumber, default: 1
  attribute :percentage,  Float,      default: 0.0
  attribute :status,      Symbol,     default: :unread

  private

  def time_now
    Time.parse('2015-09-08').utc
  end
end
