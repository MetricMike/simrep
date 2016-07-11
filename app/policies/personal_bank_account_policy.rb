class PersonalBankAccountPolicy < ApplicationPolicy

  def has_control?
    @user.admin? or record.owner == @character
  end

  class Scope
    attr_reader :user, :character, :chapter, :scope

    def initialize(context, scope)
      @user = context.user
      @character = context.character
      @chapter = context.chapter
      @scope = scope
    end

    def resolve
      @scope = scope.where(chapter: @chapter, owner: @character)
    end
  end

end
