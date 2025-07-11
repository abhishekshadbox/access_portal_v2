class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :parent_email, :string
    add_column :users, :parental_consent, :boolean
  end
end
