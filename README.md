# MultiModelPaginator
## Dependencies
* kaminari
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

```
parinator = MultiModelPaginator.new(per: 100, page: 0)
parinator.add(Account.all)
parinator.add(Post.all
parinator.result
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
