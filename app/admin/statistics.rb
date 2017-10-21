ActiveAdmin.register_page "Statistics" do
  menu false

  content do
    panel "Frequencies" do
      tabs do
        tab :skills do
          skill_freqs = CharacterSkill.group(:character_id).count.group_by(&:last).map do |k,v|
            [k, v.count]
          end.sort_by(&:last).to_h

          columns do
            column span: 3 do
              line_chart skill_freqs, xtitle: 'Characters', ytitle: 'Skills'
            end
            column do
              dl do
                skill_freqs.descriptive_statistics.map do |k,v|
                  dt k
                  dd v
                end
              end
            end
          end
        end

        tab :perks do
          perk_freqs = CharacterPerk.group(:character_id).count.group_by(&:last).map do |k,v|
            [k, v.count]
          end.sort_by(&:last).to_h

          columns do
            column span: 3 do
              line_chart perk_freqs, xtitle: 'Characters', ytitle: 'Perks'
            end
            column do
              dl do
                perk_freqs.descriptive_statistics.map do |k,v|
                  dt k
                  dd v
                end
              end
            end
          end
        end

        tab :talents do
          talent_freqs = Talent.group(:character_id).count.group_by(&:last).map do |k,v|
            [k, v.count]
          end.sort_by(&:last).to_h

          columns do
            column span: 3 do
              line_chart talent_freqs, xtitle: 'Characters', ytitle: 'Talents'
            end
            column do
              dl do
                talent_freqs.descriptive_statistics.map do |k,v|
                  dt k
                  dd v
                end
              end
            end
          end
        end
      end

    end

  end
end
