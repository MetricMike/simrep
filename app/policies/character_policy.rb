class CharacterPolicy < ApplicationPolicy
  attr_reader :character
  
  def initialize(user, character)
    @user = user
    @character = character
  end
  
  def owned?
    @character.user_id == @user.id
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
    false
  end
  
  class Scope < Scope
    def resolve
      scope.where :user_id => @user.id
    end
  end
end
