require 'spec_helper'

describe 'Lean::Attributes' do
  let(:author) { Author.new(name: 'Leo Tolstoy', age: nil) }
  let(:book) do
    Book.new.tap do |book|
      book.authors    = 'Leo Tolstoy'
      book.edition    = :first
      book.finished   = '2015-09-10'
      book.format     = 'paperback'
      book.pages      = '1'
      book.price      = 10.00
      book.published  = '1869-01-01'
      book.sold       = '2015-09-08'
      book.title      = 'War and Peace'
    end
  end

  it { expect(author.age).to be_nil }
  it { expect(author.name).to match 'Leo Tolstoy' }

  describe '#attributes' do
    it do
      expect(book.attributes).to match(
        authors:    ['Leo Tolstoy'],
        edition:    'first',
        finished:   DateTime.parse('2015-09-10'),
        format:     :paperback,
        pages:      1,
        price:      BigDecimal.new(10, 0),
        published:  Date.parse('1869-01-01'),
        rate:       nil,
        sold:       Time.new('2015-09-08'),
        title:      'War and Peace'
      )
    end
  end

  context 'attributes have defaults' do
    let(:reading_progress) { ReadingProgress.new(page: nil) }

    it { expect(reading_progress.date).to be_kind_of Time }
    it { expect(reading_progress.page).to eq 1 }
    it { expect(reading_progress.status).to eq :unread }
  end

  context 'initialized with unknown attributes' do
    it 'discards them' do
      expect { ReadingProgress.new(nonexistent_attribute: true) } \
        .to_not raise_error
    end
  end

  describe 'Lean::Attributes::Basic' do
    it 'has no initializer'  do
      expect { Book.new(title: 'War and Peace') }.to raise_error(ArgumentError)
    end
  end

  describe 'Lean::Attributes::CoercionHelpers' do
    it 'has coercible and writable attributes' do
      expect(book.authors).to match_array ['Leo Tolstoy']
      expect(book.format).to eq :paperback
      expect(book.pages).to eq 1
      expect(book.price).to be_kind_of BigDecimal
      expect(book.price).to eq 10.00
      expect(book.published).to eq Date.parse('1869-01-01')
      expect(book.sold).to eq Time.new('2015-09-08')
      expect(book.title).to match 'War and Peace'
    end
  end
end
