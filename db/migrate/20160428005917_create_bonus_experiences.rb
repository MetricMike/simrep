class CreateBonusExperiences < ActiveRecord::Migration
  def change
    create_table :bonus_experiences do |t|
      t.references :character, index: true, foreign_key: true
      t.string :reason
      t.integer :amount
      t.datetime :date_awarded

      t.timestamps null: false
    end
  end
end
