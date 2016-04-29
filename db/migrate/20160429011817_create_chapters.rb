class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :name

      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        Chapter.create(name: "Bastion")
        Chapter.create(name: "Aquia")
        Chapter.create(name: "Holurheim")
        Chapter.create(name: "Last Rest")
      end
    end

  end
end
