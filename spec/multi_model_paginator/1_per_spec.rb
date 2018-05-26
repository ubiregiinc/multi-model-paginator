RSpec.describe 'MultiModelPaginator 1 per' do
  describe 'まとめて' do
    let(:per) { 1 }

    before(:all) do
      SupoortModule::Store.list = []

      14.times.map do |i|
        i = i + 1
        SupoortModule::Store.list <<
        if (14 / 2) > i
          Account.create!(name: "name#{i}", nickname: "nickname_a#{i}", admin: true)
        else
          Account.create!(name: "name#{i}", nickname: "nickname_a#{i}", admin: false)
        end
      end
      5.times.map do |i|
        SupoortModule::Store.list << Item.create!(name: "name#{i}", visible: true)
      end
      ActiveRecord::Base.logger = Logger.new(STDOUT)
    end

    it 'return records' do
      (SupoortModule::Store.list.size / per).times do |i|
        expect(make_paginator(per: per, page: i).result).to eq(SupoortModule::Store.list.each_slice(per).to_a[i])
      end
    end
  end
end
