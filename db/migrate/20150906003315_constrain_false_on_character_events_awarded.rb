class ConstrainFalseOnCharacterEventsAwarded < ActiveRecord::Migration
  def change
    change_column_default :character_events, :awarded, false
  end
end