class AddDefaultHistoryLinkToCharacters < ActiveRecord::Migration
  def change
    change_column :characters, :history_approval, :boolean, default: false
    change_column :characters, :history_link, :string, default: "https://drive.google.com/open?id=1MCJQU6CIV4UDPtRTmYJRpwfBaHW9AzcCCGL9duw7-RQ&authuser=0"
  end
end
