Sequel.migration do
  change do
    create_table(:events) do
      primary_key :id
      String      :name
      foreign_key :site_id
    end
  end
end
