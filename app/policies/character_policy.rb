class CharacterPolicy < ApplicationPolicy

  def has_control?
    @user.admin? or @record.user == @user
  end

end
