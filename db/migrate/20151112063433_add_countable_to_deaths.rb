class AddCountableToDeaths < ActiveRecord::Migration
  def change
    add_column :deaths, :countable, :boolean, default: true

    reversible do |dir|
      dir.up do
        Death.update_all(countable: true)
      end
    end
  end
end
