Sequel.migration do
  change do
    alter_table(:requests) do
      add_column :requested_at, DateTime
    end
  end
end
