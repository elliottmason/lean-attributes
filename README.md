# Lean::Attributes

Lean::Attributes is inspired by gems like [Virtus](https://github.com/solnic/virtus) or [FastAttributes](https://github.com/applift/fast_attributes). It allows one to define typed attributes on arbitrary Ruby classes. Lean::Attributes aims to be roughly as fast as FastAttributes but has a few syntactical differences in addition to support for default values.

## Status
[![Gem Version](https://badge.fury.io/rb/lean-attributes.svg)](https://badge.fury.io/rb/lean-attributes)
[![Build Status](https://travis-ci.org/lleolin/lean-attributes.svg)](https://travis-ci.org/lleolin/lean-attributes)
[![Test Coverage](https://codeclimate.com/github/lleolin/lean-attributes/badges/coverage.svg)](https://codeclimate.com/github/lleolin/lean-attributes/coverage)
[![Code Climate](https://codeclimate.com/github/lleolin/lean-attributes/badges/gpa.svg)](https://codeclimate.com/github/lleolin/lean-attributes)
[![Dependency Status](https://gemnasium.com/lleolin/lean-attributes.svg)](https://gemnasium.com/lleolin/lean-attributes)
[![Inline docs](https://inch-ci.org/github/lleolin/lean-attributes.svg?branch=master)](https://inch-ci.org/github/lleolin/lean-attributes)

## Installation
Add this line to your Gemfile:
```ruby
gem 'lean-attributes', '~> 0.3'
```

And then execute:

    $ bundle

Or install it yourself with:

    $ gem install lean-attributes

## Usage
```ruby
require 'lean-attributes'

class Book
  include Lean::Attributes

  attribute :title,     String
  attribute :name,      String
  attribute :pages,     Integer
  attribute :authors,   Array
  attribute :published, Date
  attribute :sold,      Time,     default: :time_now
  attribute :finished,  DateTime
  attribute :format,    Symbol,   default: :hardcover

  private

  def time_now
    Time.now.utc
  end
end

book = Book.new(
  title:      'There and Back Again',
  name:       'The Hobbit',
  pages:      '200',
  authors:    'Tolkien',
  published:  '1937-09-21',
)
book.finished = '1937-08-20 12:35'

book.format # => :hardcover
book.sold # => 2015-09-15 23:06:34 UTC
book # =>
# #<Book:0x007fcb7613b610
#   @authors=["Tolkien"],
#   @finished=
#     #<DateTime: 1937-08-20T12:35:00+00:00 ((2428766j,45300s,0n),+0s,2299161j)>,
#   @format=:hardcover,
#   @name="The Hobbit",
#   @pages=200,
#   @published=#<Date: 1937-09-21 ((2428798j,0s,0n),+0s,2299161j)>,
#   @sold=2015-09-15 23:06:34 UTC,
#   @title="There and Back Again">
```
### Coercion
The coercion capabilities included in this gem are poor by design and will only handle trivial use cases. Whenever you set an attribute, generated coercion methods are called. You can override these methods to create your own coercion rules.

```ruby
class ReadingProgress
  include Lean::Attributes

  attribute :current_page, Integer, default: 1

  private

  def coerce_current_page(value)
    value = begin
      value.to_i
    rescue NoMethodError
      1
    end

    value = 1 if value < 1
    value
  end
end

# progress = ReadingProgress.new(current_page: 0)
# progress.current_page # => 1
```

Another way to contain such behavior is to create a `CurrentPage` class to represent your attribute instead of an Integer. The power is yours.

## Benchmarks
Lean::Attributes is meant to be relatively lightweight and fast.

```
Lean::Attributes: without values                        :  3119783.8 i/s
FastAttributes: without values                          :  3055309.1 i/s - 1.02x slower
ActiveAttr: without values                              :  1554020.1 i/s - 2.01x slower
Lean::Attributes: integer values for integer attributes :   153202.6 i/s - 20.36x slower
Lean::Attributes: string values for integer attributes  :   141380.5 i/s - 22.07x slower
FastAttributes: integer values for integer attributes   :   121248.2 i/s - 25.73x slower
FastAttributes: string values for integer attributes    :   116990.4 i/s - 26.67x slower
Virtus: integer values for integer attributes           :    35510.1 i/s - 87.86x slower
ActiveRecord: without values                            :    33943.3 i/s - 91.91x slower
ActiveAttr: integer values for integer attributes       :    23016.1 i/s - 135.55x slower
ActiveAttr: string values for integer attributes        :    22838.5 i/s - 136.60x slower
Virtus: without values                                  :    17894.9 i/s - 174.34x slower
Attrio: integer values for integer attributes           :    16326.6 i/s - 191.09x slower
Attrio: string values for integer attributes            :    15921.3 i/s - 195.95x slower
ActiveRecord: string values for integer attributes      :    13286.4 i/s - 234.81x slower
ActiveRecord: integer values for integer attributes     :    12595.4 i/s - 247.69x slower
Attrio: without values                                  :    11723.0 i/s - 266.13x slower
Virtus: string values for integer attributes            :     4925.7 i/s - 633.36x slower
```

## Versioning
Lean:Attributes uses [Semantic Versioning 2.0.0](http://semver.org)

## Contributing
1. Fork it ( https://github.com/lleolin/lean-attributes/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright
Copyright © 2015 R. Elliott Mason – Released under MIT License
