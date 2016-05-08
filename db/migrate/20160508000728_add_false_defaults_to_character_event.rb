class AddFalseDefaultsToCharacterEvent < ActiveRecord::Migration
  def change
    change_column_default :character_events, :paid, false
    change_column_default :character_events, :cleaned, false
    change_column_default :character_events, :awarded, false
  end
end
