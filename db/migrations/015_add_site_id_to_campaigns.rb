Sequel.migration do
  change do
    alter_table(:campaigns) do
      add_column :site_id, String
    end
  end
end
