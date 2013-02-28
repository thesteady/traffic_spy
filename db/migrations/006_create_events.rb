Sequel.migration do
  change do
    create_table(:events) do
      primary_key :id
      String      :eventname
      foreign_key :app_id
    end
  end
end
