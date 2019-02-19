# Lean::Attributes

Lean::Attributes is inspired by gems like [Virtus](https://github.com/solnic/virtus) or [FastAttributes](https://github.com/applift/fast_attributes). It allows one to define typed attributes on arbitrary Ruby classes. Lean::Attributes aims to be roughly as fast as FastAttributes but has a few syntactical differences in addition to support for default values.

## Status

[![Gem Version](https://badge.fury.io/rb/lean-attributes.svg)](https://badge.fury.io/rb/lean-attributes)
[![Build Status](https://travis-ci.org/elliottmason/lean-attributes.svg)](https://travis-ci.org/elliottmason/lean-attributes)
[![Test Coverage](https://codeclimate.com/github/elliottmason/lean-attributes/badges/coverage.svg)](https://codeclimate.com/github/elliottmason/lean-attributes/coverage)
[![Code Climate](https://codeclimate.com/github/elliottmason/lean-attributes/badges/gpa.svg)](https://codeclimate.com/github/elliottmason/lean-attributes)
[![Dependency Status](https://gemnasium.com/elliottmason/lean-attributes.svg)](https://gemnasium.com/elliottmason/lean-attributes)
[![Inline docs](https://inch-ci.org/github/elliottmason/lean-attributes.svg?branch=master)](https://inch-ci.org/github/elliottmason/lean-attributes)

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
FastAttributes: without values                          :  3830507.7 i/s
Lean::Attributes: without values                        :  3670545.2 i/s - 1.04x slower
ActiveAttr: without values                              :  1818005.4 i/s - 2.11x slower
Lean::Attributes: integer values for integer attributes :   191991.7 i/s - 19.95x slower
Lean::Attributes: string values for integer attributes  :   167686.5 i/s - 22.84x slower
dry-types: integer values for integer attributes        :   160914.8 i/s - 23.80x slower
FastAttributes: integer values for integer attributes   :   160370.0 i/s - 23.89x slower
dry-types: string values for integer attributes         :   144054.6 i/s - 26.59x slower
FastAttributes: string values for integer attributes    :   136264.1 i/s - 28.11x slower
ActiveRecord: without values                            :    56582.9 i/s - 67.70x slower
Virtus: integer values for integer attributes           :    36116.4 i/s - 106.06x slower
ActiveAttr: integer values for integer attributes       :    27098.4 i/s - 141.36x slower
ActiveAttr: string values for integer attributes        :    26135.1 i/s - 146.57x slower
Attrio: integer values for integer attributes           :    21036.0 i/s - 182.09x slower
ActiveRecord: integer values for integer attributes     :    19806.9 i/s - 193.39x slower
ActiveRecord: string values for integer attributes      :    19789.4 i/s - 193.56x slower
Virtus: without values                                  :    19297.2 i/s - 198.50x slower
Attrio: string values for integer attributes            :    19294.7 i/s - 198.53x slower
Attrio: without values                                  :    14396.8 i/s - 266.07x slower
Virtus: string values for integer attributes            :     6548.1 i/s - 584.98x slower
```

## Versioning

Lean:Attributes uses [Semantic Versioning 2.0.0](http://semver.org)

## Contributing

1. Fork it ( https://github.com/elliottmason/lean-attributes/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright © 2015 R. Elliott Mason – Released under MIT License
