class CharactersController < ApplicationController
  before_action :authenticate_user!

  before_action :sign_in_character, except: [:index, :new, :create]
  before_action :sign_out_character, only: :index

  after_action :verify_authorized, :except => :index
  after_action :verify_policy_scoped, :only => :index

  def index
    @characters = policy_scope(Character)
    @active_characters = @characters.where(retired: false)
    @retired_characters = @characters.where(retired: true)
  end

  def new
    @character = current_user.characters.new(chapter: current_chapter)
    authorize @character
  end

  def show
    @last_event = @character.events.order(weekend: :desc).pluck(:weekend).try(:first).try(:strftime, "%Y %b %d")
    @last_event = "" unless @last_event
    @filename = "#{@character.name.parameterize} - #{@last_event}"

    respond_to do |format|
      format.html
      format.pdf do
        @character.attend_event(Event.order(weekend: :desc).first.id)
        @last_event = @character.events.order(weekend: :desc).pluck(:weekend).first.strftime("%Y %b %d")
        render  pdf:            "#{@filename}",
                template:       "characters/show.html.erb",
                grayscale:      true,
                page_size:      'Letter',
                save_to_file:   Rails.root.join('pdfs', "#{@filename}.pdf"),
                header:         { center: 'SimTerra Character Sheet' },
                footer:         { left: "#{@character.user.name}",
                                  right: "For #{@last_event} Event" },
                show_as_html:   params[:debug].present?
      end
    end
  end

  def edit
    # No way to reach here, the route is gone!
  end

  def create
    @character = current_user.characters.new(character_params)
    authorize @character

    if @character.save
      redirect_to @character, notice: 'Character created successfully.'
    else
      render action: :new
    end
  end

  def update
    # Only thing you can do here is move between chapters
    if @character.update_attributes(chapter_id: params[:chapter])
      session[:current_chapter_id] = params[:chapter]; @chapter = current_chapter
      redirect_to @character, notice: 'Character moved successfully.'
    else
      render action: :edit
    end
  end

  def destroy
    # @character.update(retired: true)
    # But I'm not ready to let PCs self-retire JUST yet
  end

  def alt_chapter
    case current_chapter.name
    when "Bastion"
      Chapter::HOLURHEIM
    else # Holurheim
      Chapter::BASTION
    end
  end
  helper_method :alt_chapter

  private

  def sign_in_character
    session[:current_char_id] = params[:id]
    @character = Character.find(params[:id])

    # This should be redundant and can be removed
    unless @character.bank_accounts.where(chapter: current_chapter).any?
      @character.open_bankaccount
    end

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
