RSpec.describe 'MultiModelPaginator 1 per' do
  class Store
    class << self
      attr_accessor :list
    end
  end

  describe 'まとめて' do
    let(:per) { 1 }

    before(:all) do
      ActiveRecord::Base.connection.begin_transaction
      Store.list = []

      14.times.map do |i|
        i = i + 1
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

    after(:all) do
      ActiveRecord::Base.connection.rollback_transaction
      ActiveRecord::Base.logger = Logger.new('/dev/null')
    end

    it 'return records' do
      (Store.list.size / per).times do |i|
        expect(make_paginator(per: per, page: i).result).to eq(Store.list.each_slice(per).to_a[i])
      end
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
