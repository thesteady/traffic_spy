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

namespace :sanitation do
  desc "Check line lengths & whitespace with Cane"
  task :lines do
    puts ""
    puts "== using cane to check line length =="
    system("cane --no-abc --style-glob 'lib/**/*.rb' --no-doc")
    puts "== done checking line length =="
    puts ""
  end

  desc "Check method length with Reek"
  task :methods do
    puts ""
    puts "== using reek to check method length =="
    system("reek -n lib/**/*.rb 2>&1 | grep -v ' 0 warnings'")
    puts "== done checking method length =="
    puts ""
  end

  desc "Check both line length and method length"
  task :all => [:lines, :methods]
end



# THIS SPACE RESERVED FOR EVALUATIONS
#
#
#
#
# THIS SPACE RESERVED FOR EVALUATIONS
