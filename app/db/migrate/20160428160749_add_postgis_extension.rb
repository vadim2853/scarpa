class AddPostgisExtension < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute('CREATE EXTENSION IF NOT EXISTS postgis;')
  end

  def down
    ActiveRecord::Base.connection.execute('DROP EXTENSION IF EXISTS postgis CASCADE;')
  end
end
