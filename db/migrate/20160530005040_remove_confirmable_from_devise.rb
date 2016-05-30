class RemoveConfirmableFromDevise < ActiveRecord::Migration[5.0]
  def up
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email
  end

  def down
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_index :users, :confirmation_token, unique: true
    add_column :users, :unconfirmed_email, :string # Only if using reconfirmable
    # users as confirmed, do the following
    User.all.update_all confirmed_at: Time.now
  end
end
