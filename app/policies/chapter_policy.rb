class ChapterPolicy < ApplicationPolicy

  def has_access?
    true
  end

  class Scope < Scope

    def resolve
      scope.all
    end

  end
end