ActiveAdmin.register CharacterPerk do
  menu false
  member_action :history do
    @character_perk = CharacterPerk.find(params[:id])
    @versions = @character_perk.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_character_perk_path(resource)
  end

  controller do
    def show
      @character_perk = CharacterPerk.includes(versions: :item).find(params[:id])
      @versions = @character_perk.versions
      @character_perk = @character_perk.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end