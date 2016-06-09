ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    panel "App Status" do
      para %(Currently deployed: #{link_to(SimRep::Application::Version,
                                 "https://github.com/MetricMike/simrep/releases/tag/v#{SimRep::Application::Version}")}).html_safe
    end

    panel "Recently updated content" do
      versions = PaperTrail::Version.includes(:item).order(created_at: :desc).page(params[:page]).per(15)
      versions_users = User.where(id: versions.collect(&:whodunnit).reject(&:blank?).map(&:to_i).uniq)
      paginated_collection(versions, download_links: false) do
        table_for collection do
          column ("Item Type") { |v| v.item_type }
          column ("Name") { |v| link_to_if v.item, "#{v.item.try(:display_name) || v.item_id}", [:admin, v.item] }
          column ("Event") { |v| v.event }
          column ("Details") { |v| v.changeset }
          column ("Modified at") { |v| v.created_at.to_s :long }
          column ("Modified by") { |v| versions_users.select{|u| u.id == v.whodunnit.to_i}.try(:first).try(:display_name) }
        end
      end
    end
  end

end
