class UserWithContext
  attr_reader :user, :character, :chapter

  def initialize(user, character, chapter)
    @user = user
    @character = character
    @chapter = chapter
  end
end