task :save_content => :environment do
  ENV["TABLES"] = "users"
  Rake.application.invoke_task("extract_fixtures")
end

task :load_content do
  Rake.application.invoke_task("db:fixtures:load")
end

task :extract_fixtures => :environment do
  sql  = "SELECT * FROM %s"
  skip_tables = ["schema_info"]
  ActiveRecord::Base.establish_connection
  if (not ENV['TABLES'])
    tables = ActiveRecord::Base.connection.tables - skip_tables
  else
    tables = ENV['TABLES'].split(/, */)
  end
  if (not ENV['OUTPUT_DIR'])
    output_dir="/home/jmillar/Documents/my_rails/sample_app/test/fixtures"
  else
    output_dir = ENV['OUTPUT_DIR'].sub(/\/$/, '')
  end

  (tables).each do |table_name|
    i = "000"

    full_file_name = output_dir + '/' + table_name + '.yml'
    puts "#{full_file_name} +++"

    File.open("#{full_file_name}", 'w+') do |file|
      data = ActiveRecord::Base.connection.select_all(sql % table_name)
      file.write data.inject({}) { |hash, record|
        hash["#{table_name}_#{i.succ!}"] = record
        hash
      }.to_yaml
      puts "wrote #{table_name} to #{output_dir}/"
    end
  end
end

