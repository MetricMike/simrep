class GroupBankAccountPolicy < ApplicationPolicy

  def has_control?
    @user.admin? or @character.in? @record.group.members
  end

  class Scope
    attr_reader :user, :character, :scope

    def initialize(context, scope)
      @user = context.user
      @character = context.character
      @scope = scope
    end

    def resolve
      scope.where(group: @character.groups)
    end
  end

end
