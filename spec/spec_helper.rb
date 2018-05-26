require "bundler/setup"
require "pry"
require "multi_model_paginator"
require "support/models"
require "support/helper_methods"

RSpec.configure do |config|
  config.include(HelperMethods)

  config.before(:all) do
    ActiveRecord::Base.connection.begin_transaction
  end
  config.after(:all) do
    ActiveRecord::Base.connection.rollback_transaction
    ActiveRecord::Base.logger = Logger.new('/dev/null')
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
