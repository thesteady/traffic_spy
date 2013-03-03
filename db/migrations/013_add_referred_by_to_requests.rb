Sequel.migration do
  change do
    alter_table(:requests) do
      add_column :referred_by, String
    end
  end
end
