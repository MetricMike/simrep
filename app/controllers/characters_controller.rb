class CharactersController < ApplicationController
  before_action :sign_in_character, except: [:index, :new, :create]
  before_action :sign_out_character, only: :index

  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: :index

  def index
    @characters = policy_scope(Character)
    @active_characters = @characters.newest.where(retired: false)
    @retired_characters = @characters.newest.where(retired: true)
  end

  def show
    @last_event = @character.events.order(weekend: :desc).pluck(:weekend).try(:first).try(:strftime, "%Y %b %d")
    @last_event = "" unless @last_event
    @filename = "#{@character.name.parameterize} - #{@last_event}"
  end

  def print
    render layout: 'pdf.html.erb'
  end

  def new
    @default_chapter = Event.last.chapter
    @character = current_user.characters.new
    authorize @character
  end

  def create
    @character = current_user.characters.new(character_params)
    authorize @character

    if @character.save
      redirect_to @character, notice: 'Character created successfully.'
    else
      flash[:error] = @character.errors
      render action: :new
    end
  end

  def edit
    # No way to reach here, the route is gone!
  end

  # Removed route
  def update
    # Only thing you can do here is move between chapters
    # if @character.update_attributes(chapter_id: params[:chapter], unused_talents: @character.unused_talents-1)
    #   session[:current_chapter_id] = params[:chapter]; @chapter = current_chapter
    #   redirect_to @character, notice: 'Character moved successfully. 1 Time Unit removed.'
    # else
    #   flash[:error] = "Couldn't move character. Do you have Time Units available?"
    #   render action: :edit
    # end
  end

  def destroy
    # @character.update(retired: true)
    # But I'm not ready to let PCs self-retire JUST yet
  end

  private

  def sign_in_character
    session[:current_char_id] = params[:id]
    @character = Character.find(params[:id])

    authorize @character
  end

  def sign_out_character
    session[:current_char_id] = nil
    @character = nil
  end

  def character_params
    params.require(:character).permit! #ahhhhhhhh
  end
end
