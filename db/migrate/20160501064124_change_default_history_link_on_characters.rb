class ChangeDefaultHistoryLinkOnCharacters < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        change_column_default(:characters, :history_link, "https://goo.gl/DbKTlk")
      end
      dir.down do
        change_column_default(:characters, :history_link, "https://drive.google.com/open?id=1MCJQU6CIV4UDPtRTmYJRpwfBaHW9AzcCCGL9duw7-RQ&authuser=0")
      end
    end
  end
end
