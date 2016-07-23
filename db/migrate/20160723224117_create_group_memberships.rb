class CreateGroupMemberships < ActiveRecord::Migration[5.0]
  def change
    remove_column :groups, :member_id

    create_table :group_memberships do |t|
      t.references :member, foreign_key: { to_table: :characters }
      t.references :group, foreign_key: true
      t.string :position

      t.timestamps
    end
  end
end
