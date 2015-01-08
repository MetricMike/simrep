class CharactersController < ApplicationController
  before_action :authenticate_user!
  
  after_action :verify_authorized, :except => :index
  after_action :verify_policy_scoped, :only => :index
  
  def index
    # Show user's characters
    @user = current_user
    @characters = policy_scope(Character)
  end
  
  def new
    # Guided dialog for making a new character
  end
  
  def show
    # Data for a given character
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
