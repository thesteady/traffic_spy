Sequel.migration do
  change do
    create_table(:requests) do
      primary_key :id
      foreign_key :url_path_id
      foreign_key :browser_id
      foreign_key :os_id
      foreign_key :site_id
      String      :resolution
      Integer     :response_time
      foreign_key :eventname_id, :null => true
    end
  end
end
