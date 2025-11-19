class RemoveAdminIdFromOrganizations < ActiveRecord::Migration[8.0]
  def change
    remove_column :organizations, :admin_id, :integer
  end
end
