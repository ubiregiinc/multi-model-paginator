# MultiModelPaginator
* 複数のモデルでページネーションを行うgemです
* 追加されたクエリ毎のカウントをとっていい感じにページネーションします

## Dependencies
* ActiveRecord

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'multi_model_paginator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install multi_model_paginator

## Usage

```ruby
Account.count # => 3
Item.count    # => 5

paginator = MultiModelPaginator.new(per: 2, page: 0)
paginator.add(Account.all)
paginator.add(Item.all)
# D, [2018-05-29T22:28:55.104813 #7189] DEBUG -- :   CACHE  (0.0ms)  SELECT COUNT(*) FROM "accounts"
# D, [2018-05-29T22:28:55.105422 #7189] DEBUG -- :   CACHE Account Load (0.0ms)  SELECT  "accounts".* FROM "accounts" LIMIT 2 OFFSET 0
paginator.result.map(&:class).map(&:to_s) # =>["Account", "Account"]

paginator = MultiModelPaginator.new(per: 2, page: 1)
paginator.add(Account.all)
paginator.add(Item.all)
# D, [2018-05-29T22:29:37.069335 #7189] DEBUG -- :   CACHE  (0.0ms)  SELECT COUNT(*) FROM "accounts"
# D, [2018-05-29T22:29:37.069765 #7189] DEBUG -- :   CACHE Account Load (0.0ms)  SELECT  "accounts".* FROM "accounts" LIMIT 2 OFFSET 2
# D, [2018-05-29T22:29:37.070255 #7189] DEBUG -- :   CACHE  (0.0ms)  SELECT COUNT(*) FROM "items"
# D, [2018-05-29T22:29:37.070821 #7189] DEBUG -- :   CACHE Item Load (0.0ms)  SELECT  "items".* FROM "items" LIMIT 2 OFFSET 0
paginator.result.map(&:class).map(&:to_s) # => ["Account", "Item"]
```

## Development
* docker compose run --rm app bash
* bundle install
* bundle exec rake

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
