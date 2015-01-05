class RecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user

  # Enforces access right checks for individuals resources
  after_action :verify_authorized, :except => :index
 
  # Enforces access right checks for collections
  after_action :verify_policy_scoped, :only => :index
  
  def show
    @characters = @user.characters.all
    @characters.each { |c| authorize c }
  end
  
  private
  
  def find_user
    @user = params[:id] ? User.find(params[:id]) : current_user
  end
end
