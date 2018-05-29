RSpec.describe 'MultiModelPaginator short_per' do
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

  describe '#count_all' do
    it 'return sum count from queies' do
      expect(make_paginator(per: 1, page: 0).count_all).to eq(19)
      expect(make_paginator(per: 3, page: 9).count_all).to eq(19)
    end
  end

  describe 'per=2' do
    let(:per) { 2 }

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
    context 'page=3' do
      it 'return records' do
        expect(make_paginator(per: per, page: 3).result).to eq(SupoortModule::Store.list.each_slice(per).to_a[3])
      end
    end
    context 'page=4' do
      it 'return records' do
        expect(make_paginator(per: per, page: 4).result).to eq(SupoortModule::Store.list.each_slice(per).to_a[4])
      end
    end
    context 'page=5' do
      it 'return records' do
        expect(make_paginator(per: per, page: 5).result).to eq(SupoortModule::Store.list.each_slice(per).to_a[5])
      end
    end
    context 'page=6' do
      it 'return records' do
        expect(make_paginator(per: per, page: 6).result).to eq(SupoortModule::Store.list.each_slice(per).to_a[6])
      end
    end
    context 'page=7' do
      it 'return records' do
        expect(make_paginator(per: per, page: 7).result).to eq(SupoortModule::Store.list.each_slice(per).to_a[7])
      end
    end
    context 'page=8' do
      it 'return records' do
        expect(make_paginator(per: per, page: 8).result).to eq(SupoortModule::Store.list.each_slice(per).to_a[8])
      end
    end
    context 'page=9' do
      it 'return records' do
        expect(make_paginator(per: per, page: 9).result).to eq(SupoortModule::Store.list.each_slice(per).to_a[9])
      end
    end
  end

  describe 'per=100' do
    let(:per) { 100 }
    it 'return records' do
      expect(make_paginator(per: per, page: 0).result).to eq(SupoortModule::Store.list.each_slice(per).to_a[0])
    end
  end

  describe 'まとめて' do
    let(:per) { 5 }

    it 'return records' do
      (SupoortModule::Store.list.size / per).times do |i|
        expect(make_paginator(per: per, page: i).result).to eq(SupoortModule::Store.list.each_slice(per).to_a[i])
      end
    end
  end
end
