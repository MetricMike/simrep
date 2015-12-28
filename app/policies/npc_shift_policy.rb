class NpcShiftPolicy < ApplicationPolicy

  def has_control?
    @user.admin? or record.character == @character
  end

  class Scope < Scope

    def resolve
      scope.where(character_event: @character.character_events)
    end

  end
end