class CharactersController < ApplicationController
  before_action authenticate_user!
  
  def index
    # Show all orphaned characters
    @characters = User.find_by(email: 'orphaned@example.com').characters.all
  end
  
  def new
    #form
  end
  
  def show
    #sheet with all pertinent
  end
  
  def edit
    #form to make changes
  end
  
  def create
  end
  
  def update
  end
  
  def destroy
  end
end
