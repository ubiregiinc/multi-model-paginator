RSpec.describe MultiModelPaginator do
  class Store
    class << self
      attr_accessor :list
    end
  end
  Store.list = []

  it "has a version number" do
    expect(MultiModelPaginator::VERSION).not_to be nil
  end

  describe '#new' do
    before(:all) do
      14.times.map do |i|
        Store.list <<
          if (14 / 2) > i
            Account.create!(name: "name#{i}", nickname: "nickname_a#{i}", admin: true)
          else
            Account.create!(name: "name#{i}", nickname: "nickname_a#{i}", admin: false)
          end
      end
      5.times.map do |i|
        Store.list << Item.create!(name: "name#{i}", visible: true)
      end
      ActiveRecord::Base.logger = Logger.new(STDOUT)
    end

    context 'per=2' do
      let(:per) { 2 }

      context 'page=0' do
        it 'return records' do
          expect(make_paginator(per: per, page: 0).result).to eq(Store.list[0..1])
        end
      end
      context 'page=1' do
        it 'return records' do
          expect(make_paginator(per: per, page: 1).result).to eq(Store.list[0..1])
        end
      end
      context 'page=2' do
        it 'return records' do
          expect(make_paginator(per: per, page: 2).result).to eq(Store.list[2..3])
        end
      end
      context 'page=3' do
        it 'return records' do
          expect(make_paginator(per: per, page: 3).result).to eq(Store.list[4..5])
        end
      end
      context 'page=4' do
        it 'return records' do
          expect(make_paginator(per: per, page: 4).result).to eq(Store.list[5..6])
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
