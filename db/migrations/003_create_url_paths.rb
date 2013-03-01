Sequel.migration do
  change do
    create_table(:url_paths) do
      primary_key :id
      String      :path
      foreign_key :site_id
    end
  end
end
