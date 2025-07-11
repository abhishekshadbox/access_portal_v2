class AddCreatorIdToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :creator_id, :integer
    add_foreign_key :posts, :users, column: :creator_id
    add_index :posts, :creator_id
  end
end
