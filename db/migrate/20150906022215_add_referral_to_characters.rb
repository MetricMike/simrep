 class AddReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.references :referred_user, references: :users, index: true
      t.references :referring_user, references: :users, index: true
      t.references :event_claimed
    end

    add_foreign_key :referrals, :users, column: :referring_user_id
    add_foreign_key :referrals, :users, column: :referred_user_id
    add_index :referrals, :referred_user, unique: true
  end
end