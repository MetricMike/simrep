class ProjectPolicy < ApplicationPolicy

  def has_control?
    @user.admin? or record.leader == @character
  end

  def has_access?
    has_control? or @character.project_contributions.exists? project_id: @record
  end

  class Scope < Scope

    def resolve
      @character.projects
    end

  end
end
