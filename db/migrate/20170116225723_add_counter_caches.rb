class AddCounterCaches < ActiveRecord::Migration[5.0]
  def change
    add_column :skills, :characters_count, :integer, default: 0
    add_column :perks, :characters_count, :integer, default: 0
    add_column :origins, :characters_count, :integer, default: 0
    add_column :birthrights, :characters_count, :integer, default: 0

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<-SQL.squish
        UPDATE skills
           SET characters_count = (SELECT count(1)
                                   FROM character_skills
                                  WHERE character_skills.skill_id = skills.id)
    SQL

    execute <<-SQL.squish
        UPDATE perks
           SET characters_count = (SELECT count(1)
                                   FROM character_perks
                                  WHERE character_perks.perk_id = perks.id)
    SQL

    execute <<-SQL.squish
        UPDATE origins
           SET characters_count = (SELECT count(1)
                                   FROM character_origins
                                  WHERE character_origins.origin_id = origins.id)
    SQL

    execute <<-SQL.squish
        UPDATE birthrights
           SET characters_count = (SELECT count(1)
                                   FROM character_birthrights
                                  WHERE character_birthrights.birthright_id = birthrights.id)
    SQL
  end
end
