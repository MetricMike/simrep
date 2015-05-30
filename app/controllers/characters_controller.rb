class CharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user!

  after_action :verify_authorized, :except => :index
  after_action :verify_policy_scoped, :only => :index

  def index
    @characters = policy_scope(Character)
    session[:current_char_id] = nil
  end

  def new
    @character = @user.characters.new
    authorize @character
  end

  def show
    @character = Character.find_by id: params[:id]
    authorize @character
    session[:current_char_id] = params[:id]
    @last_event = @character.events.order(weekend: :desc).pluck(:weekend).try(:first).try(:strftime, "%Y %b %d")
    @last_event = "" unless @last_event
    @filename = "#{@character.name} - #{@last_event}"

    respond_to do |format|
      format.html
      format.pdf do
        render  pdf:            "#{@filename}",
                template:       "characters/show.html.erb",
                grayscale:      true,
                page_size:      'Letter',
                save_to_file:   Rails.root.join('pdfs', "#{@filename}.pdf"),
                header:         { center: 'SimTerra Character Sheet' },
                footer:         { left: "#{Date.today}",
                                  right: "For #{@last_event} Event" },
                show_as_html:   params[:debug].present?
      end
    end
  end

  def edit
    @character = Character.find_by id: params[:id]
    authorize @character
  end

  def create
    @character = @user.characters.new(character_params)
    authorize @character

    if @character.save
      redirect_to @character, notice: 'Character created successfully.'
    else
      render action: :new
    end
  end

  def update
    @character = Character.find_by id: params[:id]
    authorize @character

    if @character.update_attributes(character_params)
      redirect_to @character, notice: 'Character updated successfully.'
    else
      render action: :edit
    end
  end

  def destroy
    # Will actually be "retiring"
  end

  private

  def character_params
    params.require(:character).permit! #ahhhhhhhh
  end
end
