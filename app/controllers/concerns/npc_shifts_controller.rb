class NpcShiftsController < ApplicationController
  before_action :authenticate_user!

  after_action :verify_authorized, :except => :index
  after_action :verify_policy_scoped, :only => :index

  def index
    @npc_shifts = policy_scope(NpcShift)
  end

  def show
    @npc_shift = NpcShift.find_by id: params[:id]
    authorize @npc_shift
    @npc_shift.close_shift unless @npc_shift.closing.present?
  end

  # def new
  #   I can't imagine a situation where a npc_shifts#new is called. I expect
  #   players to hit create or not at all. If I need more complicated behavior
  #   (re: anything other than a simple start), go to the command line.
  # end

  # def edit
  #   See #new
  # end

  def create
    @npc_shift = NpcShift.new(character_event: most_recent_cevent)
    authorize @npc_shift

    if @npc_shift.save && @npc_shift.open_shift
      redirect_to @npc_shift, notice: 'Opened NPC Shift successfully.'
    else
      flash[:error] = "Something went wrong: #{@npc_shift.errors.messages}\nfind HF TinyMouse!"
      render action: :new
    end
  end

  def update
    # CLose or bust. If you want anything more complicated, gtfo and command line.
    @npc_shift = NpcShift.find_by id: params[:id]
    authorize @npc_shift

    # Try closing npc_shift
    if @npc_shift.close_shift
      redirect_to @npc_shift, notice: 'Closed NPC Shift successfully.'
    else
      flash[:notice] = "Something went wrong: #{@npc_shift.errors.messages}\nfind HF TinyMouse!"
      render action: :show
    end
  end

  def destroy
    #will lock/archive npc_shift
  end

  private

  def what_cevent(character, event)
    CharacterEvent.where(character: character, event: event).first
  end

  def most_recent_cevent
    @most_recent_cevent ||= what_cevent(current_character, current_character.last_event)
  end

end