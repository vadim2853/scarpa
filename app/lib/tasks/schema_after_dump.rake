Rake::Task["db:schema:dump"].enhance do
  Rake::Task["db:schema:after_dump"].invoke
end

namespace :db do
  namespace :schema do
    desc "Remove 'spatial_ref_sys' from schema (postgis fix)"
    task after_dump: :environment do
      file_name = 'db/schema.rb'

      schema = File.read(file_name)

      schema.gsub!(/^\s*create_table "spatial_ref_sys(.*\n)*?\s*end$/, '')

      File.open(file_name, 'w') {|file| file.puts schema }
    end
  end
end
