ActiveAdmin.register Skill do
  menu false
  member_action :history do
    @skill = Skill.find(params[:id])
    @versions = @skill.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_skill_path(resource)
  end

  controller do
    def show
      @skill = Skill.includes(versions: :item).find(params[:id])
      @versions = @skill.versions
      @skill = @skill.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end