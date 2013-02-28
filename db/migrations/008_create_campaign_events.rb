Sequel.migration do
  change do
    create_join_table(:campaign_id=>campaigns, event_id =>events)
  end
end
