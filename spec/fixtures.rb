require 'bigdecimal'

class Medium
  include Lean::Attributes

  attribute :authors,   Array
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
  include Lean::Attributes::Initializer

  attribute :age,  Integer
  attribute :name, String
end

class ReadingProgress
  include Lean::Attributes

  attribute :date,    Time,    default: :time_now
  attribute :page,    Integer, default: 1
  attribute :status,  Symbol,  default: :unread

  def time_now
    Time.new('2015-09-08').utc
  end
end
