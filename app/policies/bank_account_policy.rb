class BankAccountPolicy < ApplicationPolicy

  def has_control?
    @user.admin? or record.owner == @character
  end

end
