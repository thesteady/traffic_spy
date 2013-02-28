Sequel.migration do
  change do
    create_table(:campaigns) do
      primary_key :id
      String      :campaign_name
    end
  end
end
