ActiveAdmin.register CharacterBirthright do
  menu false
  member_action :history do
    @character_birthright = CharacterBirthright.find(params[:id])
    @versions = @character_birthright.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_character_birthright_path(resource)
  end

  controller do
    def show
      @character_birthright = CharacterBirthright.includes(versions: :item).find(params[:id])
      @versions = @character_birthright.versions
      @character_birthright = @character_birthright.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end