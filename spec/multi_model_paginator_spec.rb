RSpec.describe MultiModelPaginator do
  it "has a version number" do
    expect(MultiModelPaginator::VERSION).not_to be nil
  end

  describe '#new' do
    before(:each) do
      @list = []
      14.times.map do |i|
        @list <<
          if (14 / 2) > i
            Account.create!(name: "name#{i}", nickname: "nickname_a#{i}", admin: true)
          else
            Account.create!(name: "name#{i}", nickname: "nickname_a#{i}", admin: false)
          end
      end
      5.times.map do |i|
        @list << Item.where(name: "name#{i}", visible: true)
      end

      ActiveRecord::Base.logger = Logger.new(STDOUT)
    end
    after(:each) do
      ActiveRecord::Base.logger = Logger.new('/dev/null')
      Account.delete_all
      Item.delete_all
    end

    context 'per=2' do
      let(:per) { 2 }

      context 'page=0' do
        let(:page) { 0 }
        it 'return records' do
          paginator = make_paginator(per: per, page: page)
          expect(paginator.result).to eq(@list[0..1])
        end
      end
      context 'page=1' do
        let(:page) { 1 }
        it 'return records' do
          paginator = make_paginator(per: per, page: page)
          expected = Account.where(admin: true).select(:id, :nickname).page(page).per(2).to_a
          expect(paginator.result).to eq(expected)
        end
      end
      context 'page=2' do
        let(:page) { 2 }
        it 'return records' do
          paginator = make_paginator(per: per, page: page)
          expected = Account.where(admin: true).select(:id, :nickname).page(page).per(2).to_a
          expect(paginator.result).to eq(expected)
        end
      end
      context 'page=3' do
        let(:page) { 3 }
        it 'return records' do
          paginator = make_paginator(per: per, page: page)
          expected = Account.where(admin: true).select(:id, :nickname).page(page).per(2).to_a
          expect(paginator.result).to eq(expected)
        end
      end
      context 'page=4' do
        let(:page) { 4 }
        it 'return records' do
          paginator = make_paginator(per: per, page: page)
          expected = Account.where(admin: true).select(:id, :nickname).page(page).per(2).to_a
          expect(paginator.result.size).to eq(2)
          expect(paginator.result).to eq(expected)
        end
      end
    end

    context '2モデルで終わる時' do
    end
  end

  def make_paginator(per: , page: )
    paginator = MultiModelPaginator.new(per: per, page: page)
    paginator.add(Account.where(admin: true).order(:id),
                  select: [:id, :nickname])
    paginator.add(Account.where(admin: false).order(:id),
                  select: [:id, :nickname],
                  count: ->{ Account.count - Account.where(admin: true).count })
    paginator.add(Item.where(visible: true).order(:id))
    paginator
  end
end
