Sequel.migration do
    change do
    create_table(:campaign_events) do
      primary_key :id
      Integer      :campaign_id
      Integer      :event_id
    end
  end
end
