class CharactersController < ApplicationController
  before_action :authenticate_user!

  before_action :sign_in_character, except: [:all, :index, :new, :create]
  before_action :sign_out_character, only: :index

  after_action :verify_authorized, :except => [:all, :index]
  after_action :verify_policy_scoped, :only => :index

  def index
    @characters = policy_scope(Character)
    @active_characters = @characters.newest.where(retired: false)
    @retired_characters = @characters.newest.where(retired: true)
  end

  def all
    Character.find_each(finish: 78) do |c|
      @character = c
      filename = "#{c.name.parameterize} - #{Date.today.to_s.gsub(',','')}"
      pdf = render_to_string pdf: "#{filename}",
        template:       "characters/show.html.erb",
        grayscale:      true,
        page_size:      'Letter',
        header:         { center: 'SimTerra Character Sheet' },
        footer:         { left: "#{c.try(:user, :name)}",
                          right: "Generated At #{Date.today}" }
      File.open(Rails.root.join('pdfs', "#{filename}.pdf"), 'wb') { |f| f << pdf }
    end
    head :ok
  end

  def show
    @last_event = @character.events.order(weekend: :desc).pluck(:weekend).try(:first).try(:strftime, "%Y %b %d")
    @last_event = "" unless @last_event
    @filename = "#{@character.name.parameterize} - #{@last_event}"

    respond_to do |format|
      format.html
      format.pdf do
        # @character.attend_event(Event.order(weekend: :desc).first.id)
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
