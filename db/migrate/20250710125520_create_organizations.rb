class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.text :description
      t.integer :min_age_required
      t.integer :creator_id

      t.timestamps
    end
  end
end
