class AddChaptersToEverything < ActiveRecord::Migration
  def change
    add_reference :characters, :chapter, index: true
    add_reference :bank_accounts, :chapter, index: true
    add_reference :events, :chapter, index: true

    reversible do |dir|
      dir.up do
        Character.where('created_at < ?', 1.week.ago).map { |c| c.update(chapter: Chapter.find_by(name: "Bastion")) }
        BankAccount.where('created_at < ?', 1.week.ago).map { |ba| ba.update(chapter: Chapter.find_by(name: "Bastion")) }
        Event.where('created_at < ?', 1.week.ago).where.not(campaign: "Aquia").map { |e| e.update(chapter: Chapter.find_by(name: "Bastion")) }
        Event.where('created_at < ?', 1.week.ago).where(campaign: "Aquia").map { |e| e.update(chapter: Chapter.find_by(name: "Aquia")) }

        Character.where('created_at > ?', 1.week.ago).map { |c| c.update(chapter: Chapter.find_by(name: "Holurheim")) }
        BankAccount.where('created_at > ?', 1.week.ago).map { |ba| ba.update(chapter: Chapter.find_by(name: "Holurheim")) }
      end
    end

  end

end
