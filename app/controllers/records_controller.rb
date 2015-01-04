class RecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user
  
  def show
    @characters = @user.characters
  end
  
  private
  
  def find_user
    @user = params[:type] ? current_user : User.find(params[:id])
  end
end
