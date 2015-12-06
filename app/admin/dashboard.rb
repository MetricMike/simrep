ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    panel "App Status" do
      para %(Currently deployed: #{link_to(SimRep::Application::Version,
                                 "https://github.com/MetricMike/simrep/releases/tag/v#{SimRep::Application::Version}")}).html_safe
    end

    panel "Recently updated content" do
      table_for PaperTrail::Version.order(id: :desc).limit(20) do
        column ("Model") { |v| v.item_type }
        column ("Event") { |v| v.event }
        column ("Details") { |v| v.changeset }
        column ("Object ID") { |v| link_to_if v.item, v.item_id, [:admin, v.item] }
        column ("Modified at") { |v| v.created_at.to_s :long }
        column ("Modified by") { |v| User.where(id: v.whodunnit).try(:first).try(:display_name) }
      end
    end
  end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
    # content
end
