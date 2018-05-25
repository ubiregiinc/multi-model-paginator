RSpec.describe MultiModelPaginator do
  it "has a version number" do
    expect(MultiModelPaginator::VERSION).not_to be nil
  end

  describe '#new' do
    before do
      10.times do |i|
        Account.create!(name: "name#{i}", nickname: "nickname_a#{i}", admin: true)
      end

      ActiveRecord::Base.logger = Logger.new(STDOUT)
    end

    context '1モデルで終わる時' do
      it 'return records' do
        paginator = make_paginator(per: 2, page: 0)
        expected = Account.where(admin: true).select(:id, :nickname).page(0).per(2).to_a
        expect(expected).to eq(paginator.result)
      end
    end

    context '2モデルで終わる時' do
    end
  end

  def make_paginator(per: , page: )
    paginator = MultiModelPaginator.new(per: per, page: page)
    paginator.add(Account.where(admin: true),
                  select: [:id, :nickname])
    paginator.add(Account.where(admin: false),
                  select: [:id, :nickname],
                  count: ->{ Account.count - Account.where(admin: true).count })
    paginator.add(Item.where(visible: true))
    paginator
  end
end
