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
accounts = Account.where(admin: true)
Post.all

MultiModelPaginator.new do |parinator|
  parinator.add(query: ->{ Account.all }, select: ->{})
  parinator.add(query: ->{ Post.all }, select: ->{}, count: ->{})
end
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
