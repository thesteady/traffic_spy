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

  desc "Show Tables of the Database"
  task :tables => :setup do
    puts @database.tables
  end

  task :setup do
    Sequel.extension :migration

    database_path = 'trafficspy_development'


    if ENV["TRAFFIC_SPY_ENV"] == "test"
      database_path = 'trafficspy_test'
    end

    puts "Using database: #{database_path}"
    @database = Sequel.postgres database_path
  end
end



# THIS SPACE RESERVED FOR EVALUATIONS
#
#
#
#
# THIS SPACE RESERVED FOR EVALUATIONS