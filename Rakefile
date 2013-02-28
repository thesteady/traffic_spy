require "bundler/gem_tasks"

Bundler.require

namespace :db do
  desc "Run migrations"
  task :migrate => [:setup] do
    Sequel::Migrator.run(@database, "db/migrations")
  end

  desc "Reset database"
  task :reset => [:setup] do
    Sequel::Migrator.run(@database, "db/migrations", :target => 0)
    Sequel::Migrator.run(@database, "db/migrations")
  end

  # task :setup do
  #   Sequel.extension :migration

  #   database_path = 'db/ideabox.sqlite3'

  #   if ENV["IDEA_BOX_ENV"] == "test"
  #     database_path = 'db/ideabox-test.sqlite3'
  #   end

  #   puts "Using database: #{database_path}"
  #   @database = Sequel.postgres database_path
  # end
end



# THIS SPACE RESERVED FOR EVALUATIONS
#
#
#
#
# THIS SPACE RESERVED FOR EVALUATIONS