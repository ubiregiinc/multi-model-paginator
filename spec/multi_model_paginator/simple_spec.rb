RSpec.describe 'MultiModelPaginator simple' do
  describe 'simple' do
    before do
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

    it do
      paginator = MultiModelPaginator.new(per: 10, page: 1)
      paginator.add(Account.where(admin: true))
      paginator.add(Account.where(admin: false))
      expect(paginator.result).not_to eq([])
    end
  end
end
