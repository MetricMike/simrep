class BankAccountPolicy < ApplicationPolicy

  def has_control?
    @user.admin? or record.owner == @character
  end

  class Scope < Scope

    def resolve
      @user.admin? ? scope.all : scope.where(owner: @character)
    end

  end

end
