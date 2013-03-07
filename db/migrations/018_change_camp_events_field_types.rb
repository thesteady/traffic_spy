Sequel.migration do
  change do
    alter_table(:campaign_events) do
      drop_column :campaign_id
      drop_column :event_id
      add_column :campaign_id, Integer
      add_column :event_id, Integer
    end
  end
end
