Sequel.migration do
  change do
    alter_table(:requests) do
      add_column :ip, String
    end
  end
end
