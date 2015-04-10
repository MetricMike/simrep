class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user!, :find_character!

  after_action :verify_authorized, :except => :index
  after_action :verify_policy_scoped, :only => :index

  def index
    @projects = policy_scope(Project)
  end

  def show
    @project = Project.find_by id: params[:id]
    @contributions = @project.contributions.select(&:persisted?)
    @project_contribution = @project.project_contributions.build(character: @character, timeunits: 0)
    authorize @project
  end

  def new
    @project = @character.projects.new
    authorize @project
  end

  # def edit
  #   Same-page rendering done in #show
  # end

  def create
    @project = @character.projects.new(project_params)
    authorize @project

    if @project.save
      redirect_to @project, notice: 'Project created successfully.'
    else
      render action: :new
    end
  end

  def update
    @project = Project.find_by id: params[:id]
    authorize @project

    # Try updating contribution
    if params[:project_contribution]
      params[:project_contribution][:character_id] = @character.id
      @project_contribution = @project.project_contributions.new(project_contribution_params)
        if @project_contribution.save && @character.invest_in_project(@project_contribution.timeunits, params[:project_contribution][:talent])
          redirect_to @project, notice: 'Project updated successfully'
        else
          flash[:notice] = "Something went wrong! Check your time units and transaction log!"
          render action: :show
        end
    else # Try updating project
      if @project.update_attributes(project_params)
        redirect_to @project, notice: 'Project updated successfully.'
      else
        render action: :show
      end
    end
  end

  def destroy
    #will lock/archive project
  end

  private

  def project_params
    params.require(:project).permit! #aaahhhhhhhh
  end

  def project_contribution_params
    params.require(:project_contribution).permit! #aaahhhhhhhh
  end

  def pundit_user
    @character
  end
end
