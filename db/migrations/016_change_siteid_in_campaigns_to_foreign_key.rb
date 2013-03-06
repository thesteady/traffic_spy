Sequel.migration do
  change do
    alter_table(:campaigns) do
      drop_column :site_id
      add_foreign_key :site_id, :sites
    end
  end
end
