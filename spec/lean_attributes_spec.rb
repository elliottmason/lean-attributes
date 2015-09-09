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

  context 'attributes have defaults' do
    let(:reading_progress) { ReadingProgress.new(page: nil) }

    it { expect(reading_progress.date).to be_kind_of Time }
    it { expect(reading_progress.page).to eq 1 }
    it { expect(reading_progress.status).to eq :unread }
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
