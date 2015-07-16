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

  def new
    @npc_shift = current_character.character_events.find_by(event: current_character.last_event).npc_shifts.new
    authorize @npc_shift

    if @npc_shift.save and @npc_shift.open_shift
      redirect_to npc_shifts_path, notice: 'Shift started successfully'
    else
      redirect_to npc_shifts_path, notice: "Could not start shift"
    end
  end

  # def edit
  #   Same-page rendering done in #show
  # end

  def create
    @npc_shift = NpcShift.new(npc_shift_params)
    authorize @npc_shift

    if @npc_shift.save
      redirect_to @npc_shift, notice: 'Npc_shift created successfully.'
    else
      render action: :new
    end
  end

  def update
    @npc_shift = NpcShift.find_by id: params[:id]
    authorize @npc_shift

    # Try updating npc_shift
    if @npc_shift.assign_hours(npc_shift_params[:hours_to_money].to_i, npc_shift_params[:hours_to_time].to_i)
      redirect_to @npc_shift, notice: 'Npc_shift updated successfully.'
    else
      flash[:notice] = "NPC Shift failed to update with the following error: #{@npc_shift.errors.messages}"
      render action: :show
    end
  end

  def destroy
    #will lock/archive npc_shift
  end

  private

  def npc_shift_params
    params.require(:npc_shift).permit! #aaahhhhhhhh
  end

end