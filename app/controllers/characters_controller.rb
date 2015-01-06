class CharactersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    # Show all orphaned characters
    @characters = policy_scope(Character)
  end
  
  def new
    #form
  end
  
  def show
    #sheet with all pertinent info
    @character = Character.find_by :id => params[:id]
    authorize @character
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
