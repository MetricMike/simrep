class NpcShiftsController < ApplicationController
  before_action :authenticate_user!

  after_action :verify_authorized, :except => :index
  after_action :verify_policy_scoped, :only => :index


  def index
    @npc_shifts = policy_scope(NpcShift)
    @recently_closed_npc_shifts = @npc_shifts.recently_closed
    @open_npc_shifts = @npc_shifts.active
    @most_recent_cevent = get_recent_cevent
  end

  def create
    @npc_shift = NpcShift.new(character_event: get_recent_cevent)
    authorize @npc_shift

    if @npc_shift.save && @npc_shift.open_shift
      flash[:notice] = 'Opened NPC Shift successfully.'
    else
      flash[:error] = "Something went wrong: #{@npc_shift.errors.messages}\nfind HF TinyMouse!"
    end
    redirect_to npc_shifts_path
  end

  def update
    # CLose or bust. If you want anything more complicated, gtfo and command line.
    @npc_shift = NpcShift.find(params[:id])
    authorize @npc_shift

    # Try closing npc_shift
    if @npc_shift.close_shift
      flash[:notice] = 'Closed NPC Shift successfully.'
    else
      flash[:error] = "Something went wrong: #{@npc_shift.errors.messages}\nfind HF TinyMouse!"
    end
    redirect_to npc_shifts_path
  end

  def can_i_open_a_shift?
    get_recent_cevent && @open_npc_shifts.count == 0
  end
  helper_method :can_i_open_a_shift?

  private

  def get_recent_cevent
    @most_recent_cevent ||= what_cevent(current_character, current_character.last_event)
  end

  def what_cevent(character, event)
    CharacterEvent.where(character: character, event: event).first
  end

end