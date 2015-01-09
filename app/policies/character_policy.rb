class CharacterPolicy < ApplicationPolicy
  attr_reader :character
  
  def initialize(user, character)
    @user = user
    @character = character
  end
  
  def owned?
    @user.admin? or @character.user_id == @user.id
  end
  
  def show?
    owned?
  end
  
  def create?
    @user.present?
  end
  
  def update?
    owned?
  end
  
  def destroy?
    @user.admin?
  end
  
  class Scope < Scope
    attr_reader :user, :scope
    
    def initialize(user, scope)
      @user = user
      @scope = scope
    end
    
    def resolve
      if @user.admin?
        scope.all
      else
        scope.where :user_id => @user.id
      end
    end
  end
end
