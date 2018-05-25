require "multi_model_paginator/version"

module MultiModelPaginator
  class QueryStruct
    attr_reader :query
    def initialize(query, select, count)
      @query = query
      @select = select
      @count = count
    end

    def query_with_select
      @query.select(@select)
    end

    def count
      @count || @query.count
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
      @query_list.reduce do |a, x|
      end
    end
  end

  def self.new(per: , page: )
    Builder.new(per, page)
  end
end
