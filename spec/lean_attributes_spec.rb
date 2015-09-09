require 'spec_helper'

describe 'Lean::Attributes' do
  context 'inclusive class' do
    let(:book) do
      Book.new.tap do |book|
        book.title      = :"War and Peace"
        book.pages      = '1'
        book.authors    = 'Leo Tolstoy'
        book.published  = '1869-01-01'
        book.sold       = '2015-09-08'
        book.finished   = '2015-09-10'
        book.price      = 10.00
        book.format     = 'paperback'
      end
    end

    it 'has no initializer'  do
      expect { Book.new(title: 'War and Peace') } \
        .to raise_error(ArgumentError)
    end

    it 'has coercible and writable attributes' do
      expect(book.title).to match 'War and Peace'
      expect(book.pages).to eq 1
      expect(book.authors).to match_array ['Leo Tolstoy']
      expect(book.published).to eq Date.parse('1869-01-01')
      expect(book.sold).to eq Time.new('2015-09-08')
      expect(book.price).to be_kind_of BigDecimal
      expect(book.price).to eq 10.00
      expect(book.format).to eq :paperback
    end
  end

  context 'inclusive class with Initializer' do
    let(:author) { Author.new(name: 'Elliott Mason', age: 30) }

    it { expect(author.name).to match 'Elliott Mason' }
    it { expect(author.age).to eq 30 }
  end

  context 'inclusive class with attribute defaults' do
    let(:reading_progress) { ReadingProgress.new }

    it { expect(reading_progress.page).to eq 1 }
    it { expect(reading_progress.date).to be_kind_of Time }
    it { expect(reading_progress.status).to eq :unread }
  end
end
