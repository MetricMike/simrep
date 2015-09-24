class AddFreeCleaningToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :free_cleaning_event, references: :events, index: true
    add_foreign_key :users, :events, column: :free_cleaning_event_id
  end
end