Sequel.migration do
  change do
    alter_table(:requests) do
      rename_column :eventname_id, :event_id
    end
  end
end
