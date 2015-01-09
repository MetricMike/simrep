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
    authorize @project
  end
  
  def new
    @project = @character.projects.new
    authorize @project
  end

  def edit
    @project = Project.find_by id: params[:id]
    authorize @project
  end

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
    
    if @project.update_attributes(project_params)
      redirect_to @project, notice: 'Project updated successfully.'
    else
      render action: :edit
    end
  end

  def destroy
    #will lock/archive project
  end
  
  private
  
    def find_user!
      @user = current_user
    end
    
    def find_character!
      @character = character
    end
    
    def project_params
      params.require(:project).permit! #aaahhhhhhhh
    end
    
    def pundit_user
      @character
    end
end
