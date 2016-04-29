class AddChaptersToEverything < ActiveRecord::Migration
  def change
    add_reference :characters, :chapter, index: true
    add_reference :bank_accounts, :chapter, index: true
    add_reference :events, :chapter, index: true

    reversible do |dir|
      dir.up do
        Character.where('created_at < ?', 1.week.ago).map { |c| c.update(chapter_id: Chapter.find_by(name: "Bastion").id) }
        BankAccount.where('created_at < ?', 1.week.ago).map { |ba| ba.update(chapter_id: Chapter.find_by(name: "Bastion").id) }
        Event.where('created_at < ?', 1.week.ago).where.not(campaign: "Aquia").map { |e| e.update(chapter_id: Chapter.find_by(name: "Aquia").id) }
        Event.where('created_at < ?', 1.week.ago).where(campaign: "Aquia").map { |e| e.update(chapter_id: Chapter.find_by(name: "Aquia").id) }
      end
    end

  end

end
