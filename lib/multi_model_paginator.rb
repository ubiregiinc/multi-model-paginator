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
      @cached_count ||=
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
      @page = page.to_i
      @list = []
    end

    def add(query, select: nil, count: nil)
      @query_list.push(QueryStruct.new(query, select, count))
    end

    def result
      remain = @per
      position = @page * @per
      @query_list.reduce([]) do |accumulator, query_struct|
        prev_total_count = @query_list.reduce(0) { |a, q| q == query_struct ? (break(a)) : (a += q.count) }
        current_range = (prev_total_count...(prev_total_count + query_struct.count))
        if !current_range.include?(position)
          next(accumulator)
        end
        prev_query_offset = current_range.first
        # テーブルt1に6レコード, テーブルt2に10レコードある場合、per:10で読んだ時にpage:2はテーブルt2の5個目が先頭になる
        # |t1:......|t2:....[.].......|
        offset = (@page * @per) - prev_query_offset
        offset = 0 if offset.negative?
        list = query_struct.with_select.limit(@per).offset(offset).first(remain)
        accumulator.concat(list)
        remain = remain - list.size
        if remain == 0
          break(accumulator)
        else
          position = (@page + 1) * @per
          next(accumulator)
        end
      end
    end
  end

  def self.new(per: , page: )
    Builder.new(per, page)
  end
end
