class PersonalBankAccountPolicy < ApplicationPolicy

  def has_control?
    @user.admin? or @record.owner == @character
  end

  class Scope
    attr_reader :user, :character, :scope

    def initialize(context, scope)
      @user = context.user
      @character = context.character
      @scope = scope
    end

    def resolve
      scope.where(owner: @character)
    end
  end

end
