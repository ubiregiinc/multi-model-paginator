RSpec.describe MultiModelPaginator do
  it "has a version number" do
    expect(MultiModelPaginator::VERSION).not_to be nil
  end

  describe '#new' do
    before do
      10.times do |i|
        Account.create!(name: "name#{i}", nickname: "nickname_a#{i}", admin: true)
      end
    end

    it do
      paginator = MultiModelPaginator.new(per: 100, page: 0)
      paginator.add(Account.where(admin: true),
                    select: [:id, :nickname], 
                    count: ->{})
      paginator.add(Account.where(admin: false),
                    select: [:id, :nickname], 
                    count: ->{ Account.count - Account.where(admin: true).count })
      paginator.add(Item.where(visible: true))
      list = paginator.result
      binding.pry
      expect(list).to eq(Account.where(admin: true).per(2).page(0).to_a)
    end
  end
end
