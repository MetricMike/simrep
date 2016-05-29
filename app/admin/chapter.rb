ActiveAdmin.register Chapter do
  menu false

  member_action :history do
    @chapter = Chapter.find(params[:id])
    @versions = @chapter.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_chapter_path(resource)
  end

  controller do
    def show
      @chapter = Chapter.includes(versions: :item).find(params[:id])
      @versions = @chapter.versions
      @chapter = @chapter.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end