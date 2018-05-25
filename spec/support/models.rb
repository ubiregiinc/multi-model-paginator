require "active_record"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

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
