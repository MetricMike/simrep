class UserWithContext
  attr_reader :user, :character

  def initialize(user, character)
    @user = user
    @character = character
  end
end