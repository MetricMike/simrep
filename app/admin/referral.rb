ActiveAdmin.register Referral do
  menu false

  index do
    selectable_column
    column :id do |r|
      link_to r.id, admin_referral_path(r)
    end
    column "Sponsor" do |r|
      link_to r.sponsor.name, admin_user_path(r.sponsor)
    end
    column "Referral" do |r|
      link_to r.referred_user.name, admin_user_path(r.referred_user)
    end
    column "Claimed?" do |r|
      status_tag (r.event_claimed ? :yes : :no)
    end
    actions
  end

end
