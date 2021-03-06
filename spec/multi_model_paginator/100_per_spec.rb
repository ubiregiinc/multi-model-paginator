require 'spec_helper'

RSpec.describe 'MultiModelPaginator 10 per' do
  describe '#new' do
    let(:per) { 10 }

    before(:all) do
      SupoortModule::Store.list = []

      324.times.map do |i|
        i = i + 1
        SupoortModule::Store.list <<
          if (14 / 2) > i
            Account.create!(name: "name#{i}", nickname: "nickname_a#{i}", admin: true)
          else
            Account.create!(name: "name#{i}", nickname: "nickname_a#{i}", admin: false)
          end
      end
      123.times.map do |i|
        SupoortModule::Store.list << Item.create!(name: "name#{i}", visible: true)
      end
      ActiveRecord::Base.logger = Logger.new(STDOUT)
    end

    context 'page=0' do
      it 'return records' do
        expect(make_paginator(per: per, page: 0).result).to eq(SupoortModule::Store.list.each_slice(per).to_a[0])
      end
    end
    context 'page=1' do
      it 'return records' do
        expect(make_paginator(per: per, page: 1).result).to eq(SupoortModule::Store.list.each_slice(per).to_a[1])
      end
    end
    context 'page=2' do
      it 'return records' do
        expect(make_paginator(per: per, page: 2).result).to eq(SupoortModule::Store.list.each_slice(per).to_a[2])
      end
    end

    it 'return records' do
      (SupoortModule::Store.list.size / per).times do |i|
        expect(make_paginator(per: per, page: i).result).to eq(SupoortModule::Store.list.each_slice(per).to_a[i])
      end
    end
  end
end
