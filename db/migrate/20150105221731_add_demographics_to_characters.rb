class AddDemographicsToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :race, :string
    add_column :characters, :culture, :string
    add_column :characters, :costume, :integer
    add_column :characters, :costume_checked, :date
    add_column :characters, :history_approval, :boolean
    add_column :characters, :history_link, :string
  end
end
