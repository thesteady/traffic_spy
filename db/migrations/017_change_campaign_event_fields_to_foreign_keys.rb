Sequel.migration do
  change do
    alter_table(:campaign_events) do
      drop_column :campaign_id
      drop_column :event_id
      add_foreign_key :campaign_id, :campaigns
      add_foreign_key :event_id, :events
    end
  end
end
