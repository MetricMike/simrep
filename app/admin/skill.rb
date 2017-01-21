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

  scope("All")          { |scope| scope.latest }
  scope("Popular (>5)") { |scope| scope.popular.latest }
  scope("Canon")        { |scope| scope.canon.latest }
  scope("Non-Canon")    { |scope| scope.non_canon.latest }

  index do
    selectable_column
    column :id
    column :source
    column :name
    column :cost
    column :canon do |s|
      status_tag (s.reviewed_at.present? ? :yes : :no)
    end
    column "In Use By" do |s|
      s.character_skills.count
    end
    actions
  end

  form do |f|
    f.inputs do
      input :source, as: :select, collection: Skill::SOURCES
      input :name
      input :cost
      input :reviewed_at, as: :date_time_picker, datetime_picker_options: { step: 15, value: Time.current }
    end

    f.actions
  end

  filter :source
  filter :name
  filter :cost
  filter :reviewed_at

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