require "active_record"

# https://github.com/rails/rails/blob/master/guides/bug_report_templates/active_record_migrations_gem.rb
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:", prepared_statements: false

class Account < ActiveRecord::Base
  connection.create_table table_name, force: true do |t|
    t.string :name
    t.string :nickname
    t.boolean :admin
  end
end

class Item < ActiveRecord::Base
  connection.create_table table_name, force: true do |t|
    t.string :name
    t.boolean :visible
  end
end
