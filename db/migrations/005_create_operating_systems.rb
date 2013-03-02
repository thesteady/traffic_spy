Sequel.migration do
  change do
    create_table(:operating_systems) do
      primary_key :id
      String      :name
    end
  end
end
