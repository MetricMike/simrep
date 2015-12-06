ActiveAdmin.register CharacterBackground do
  member_action :history do
    @character_background = CharacterBackground.find(params[:id])
    @versions = @character_background.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_character_background_path(resource)
  end

  controller do
    def show
      @character_background = CharacterBackground.includes(versions: :item).find(params[:id])
      @versions = @character_background.versions
      @character_background = @character_background.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end