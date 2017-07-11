class BankAccountPolicy < ApplicationPolicy

  def has_control?
    return if @user.admin?
    if record.type == "PersonalBankAccount"
      record.owner == @character
    else # Group
      @character.in? record.group.members
    end
  end

  class Scope
    attr_reader :user, :character, :scope

    def initialize(context, scope)
      @user = context.user
      @character = context.character
      @scope = scope
    end

    def resolve
      if @user.admin?
        scope.all
      else
        scope.where(owner: @character)
      end
    end
  end

end
