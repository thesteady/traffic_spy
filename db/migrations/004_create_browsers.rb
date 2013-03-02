Sequel.migration do
  change do
    create_table(:browsers) do
      primary_key :id
      String      :name
    end
  end
end
