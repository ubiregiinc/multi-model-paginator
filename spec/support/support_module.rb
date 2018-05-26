module SupoortModule
  class Store
    class << self
      attr_accessor :list
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
