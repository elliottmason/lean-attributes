require 'spec_helper'

describe 'Lean::Attributes' do
  let(:author) { Author.new(name: 'Leo Tolstoy', age: nil) }
  let(:book) do
    Book.new.tap do |book|
      book.authors        = 'Leo Tolstoy'
      book.edition        = :first
      book.finished       = '2015-09-10'
      book.format         = 'paperback'
      book.pages          = '1'
      book.price          = 10.00
      book.public_domain  = true
      book.published      = '1869-01-01'
      book.sold           = '2015-09-08'
      book.title          = 'War and Peace'
    end
  end

  it { expect(author.age).to be_nil }
  it { expect(author.name).to match 'Leo Tolstoy' }

  it { expect(book).to respond_to :coerce_authors }
  it { expect(author).to respond_to :coerce_age }

  describe 'generated methods' do
    it { expect(author).to respond_to :age }
    it { expect(author).to respond_to :age= }
    it { expect(author).to respond_to :coerce_age }
  end

  describe '#attributes' do
    it 'returns all attributes as a Hash' do
      expect(book.attributes).to match(
        authors:        ['Leo Tolstoy'],
        edition:        'first',
        finished:       DateTime.parse('2015-09-10'),
        format:         :paperback,
        pages:          1,
        price:          BigDecimal.new(10, 0),
        public_domain:  true,
        published:      Date.parse('1869-01-01'),
        rate:           nil,
        sold:           Time.parse('2015-09-08').utc,
        title:          'War and Peace'
      )
    end
  end

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

  describe 'coercion' do
    it 'has coercible and writable attributes' do
      expect(book.authors).to match_array ['Leo Tolstoy']
      expect(book.format).to eq :paperback
      expect(book.pages).to eq 1
      expect(book.price).to be_kind_of BigDecimal
      expect(book.price).to eq 10.00
      expect(book.published.strftime('%Y-%m-%d')).to eq '1869-01-01'
      expect(book.sold.strftime('%Y-%m-%d')).to eq '2015-09-08'
      expect(book.title).to match 'War and Peace'
    end

    it 'methods can be overridden' do
      klass =
        Class.new do
          include Lean::Attributes

          attribute :amount, Integer

          private

          def coerce_amount(value)
            value * 3
          end
        end

      expect(klass.new(amount: 3).amount).to eq 9
    end
  end
end
