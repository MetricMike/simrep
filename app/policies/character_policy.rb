class CharacterPolicy < ApplicationPolicy
  attr_reader :user, :character
  
  def initialize(user, character)
    @user = user
    @character = character
  end
  
  def owned?
    @character.user_id == @user.id
  end
  
  def index?
    true
  end
  
  def show?
    owned?
  end
  
  def create?
    true
  end
  
  def update?
    owned?
  end
  
  def destroy?
    false
  end
  
  class Scope < Scope
    def resolve
      scope.where :user_id => 1 #orphaned characters belong to uid 1
    end
  end
end
