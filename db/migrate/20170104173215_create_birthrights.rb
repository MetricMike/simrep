class CreateBirthrights < ActiveRecord::Migration
  def change
    create_table :birthrights do |t|
      t.string :source
      t.string :name
      t.string :detail

      t.timestamps null: false
    end
  end
end
