class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name, index: true
      t.string :bylaws
      t.references :member, foreign_key: { to_table: :characters }

      t.timestamps
    end
  end
end
