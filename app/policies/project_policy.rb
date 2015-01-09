class ProjectPolicy < ApplicationPolicy
  attr_reader :character, :project
  
  def initialize(character, project)
    @character = character
    @project = project
  end
  
  def owned?
    @character.user.admin? or @project.leader == @character.id
  end
  
  def contributor?
    @character.character_projects.find_by id: @project_id
  end
  
  def show?
    owned? or contributor?
  end
  
  def create?
    @character.present?
  end
  
  def update?
    owned? or contributor?
  end
  
  def destroy?
    @character.user.admin? or owned?
  end
  
  class Scope < Scope
    attr_reader :character, :project, :character_project
    
    def initialize(character, project)
      @character = character
      @project = project
      @character_project = @character.character_projects
    end
    
    def resolve
      if @character.user.admin?
        @project.all
      else
        @character.projects
      end
    end
  end
end
