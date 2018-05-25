require "multi_model_paginator/version"

module MultiModelPaginator
  class QueryStruct
    attr_reader :query

    def initialize(query, select, count)
      @query = query
      @select = select
      @count = count
    end

    def with_select
      @query.select(@select)
    end

    def count
      if @count.nil?
        @query.count
      else
        @count.call
      end
    end
  end

  class Builder
    def initialize(per, page)
      @query_list = []
      @per = per
      @page = page
      @list = []
    end

    def add(query, select: nil, count: nil)
      @query_list << QueryStruct.new(query, select, count)
    end

    def result
      remain = @per
      @page
      page_table = {
      }
      @query_list.reduce([]) do |accumulator, query|
        if query.count >= remain
          accumulator.concat(query.with_select.page(@page).per(remain))
          break(accumulator)
        end
        break(accumulator) if accumulator.size >= @per
        accumulator << query.page(@page).per(1)
        next(accumulator)
      end
    end
  end

  def self.new(per: , page: )
    Builder.new(per, page)
  end
end
