class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :min_age_required
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
