require 'spec_helper'

RSpec.describe 'MultiModelPaginator simple' do
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
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  describe '#result' do
    context 'out of page' do
      it 'return empty list' do
        paginator = MultiModelPaginator.new(per: 10, page: 5)
        paginator.add(Account.where(admin: true))
        paginator.add(Account.where(admin: false))
        expect(paginator.result).to eq([])
      end
    end

    context 'in page' do
      it 'return list' do
        paginator = MultiModelPaginator.new(per: 10, page: 1)
        paginator.add(Account.where(admin: true))
        paginator.add(Account.where(admin: false))
        expect(paginator.result).to eq(SupoortModule::Store.list[(10 * 1)..(10 * 2)])
      end
    end
  end
end
