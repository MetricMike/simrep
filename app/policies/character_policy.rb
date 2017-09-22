class CharacterPolicy < ApplicationPolicy

  def has_control?
    @user.admin? or @record.user == @user
  end

  class Scope
    attr_reader :user, :character, :scope

    def initialize(context, scope)
      @user = context.user
      @character = context.character
      @scope = scope.includes(:chapter)
    end

    def resolve
      @user.admin? ? @scope.all : @scope.where(user: @user)
    end
  end

end
