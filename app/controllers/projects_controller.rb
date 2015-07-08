class ProjectsController < ApplicationController
  before_action :authenticate_user!

  after_action :verify_authorized, :except => :index
  after_action :verify_policy_scoped, :only => :index

  def index
    @projects = policy_scope(Project)
  end

  def show
    @project = Project.find_by id: params[:id]
    @contributions = @project.contributions(current_character).select(&:persisted?)
    @project_contribution = @project.project_contributions.build(character: current_character, timeunits: 0)
    authorize @project
  end

  def new
    @project = current_character.projects.new(leader: current_character)
    @project_contribution = @project.project_contributions.build(character: current_character, timeunits: 0)
    authorize @project
  end

  # def edit
  #   Same-page rendering done in #show
  # end

  def create
    @project = Project.new(project_params)
    @project_contribution = @project.project_contributions.new(project_contribution_params)
    authorize @project

    if @project.save && @project_contribution.save
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
      params[:project_contribution][:character_id] = current_character.id
      @project_contribution = @project.project_contributions.new(project_contribution_params)
        if @project_contribution.save
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

end
