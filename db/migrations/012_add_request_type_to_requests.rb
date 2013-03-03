Sequel.migration do
  change do
    alter_table(:requests) do
      add_column :request_type, String
    end
  end
end
