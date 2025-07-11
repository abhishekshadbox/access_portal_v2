class AddRoleToSubscriptions < ActiveRecord::Migration[8.0]
  def change
    add_column :subscriptions, :role, :string, default: "viewer"
  end
end
