ActiveAdmin.register CharacterSkill do
  menu false
  member_action :history do
    @character_skill = CharacterSkill.find(params[:id])
    @versions = @character_skill.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_character_skill_path(resource)
  end

  controller do
    def show
      @character_skill = CharacterSkill.includes(versions: :item).find(params[:id])
      @versions = @character_skill.versions
      @character_skill = @character_skill.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end