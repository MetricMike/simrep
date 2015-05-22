class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user!, :find_character!

  after_action :verify_authorized, :except => :index
  after_action :verify_policy_scoped, :only => :index

  def index
    @bank_accounts = policy_scope(BankAccount)
    redirect_to bank_account_path(@bank_accounts.first) if @bank_accounts.count == 1
  end

  def show
    @bank_account = BankAccount.find_by id: params[:id]
    @transactions = @bank_account.transactions.select(&:persisted?)
    @bank_account_transaction = @bank_account.outgoing_transactions.build()
    authorize @bank_account
  end

  def new
    @bank_account = @character.bank_accounts.new
    authorize @bank_account
  end

  # def edit
  #   Same-page rendering done in #show
  # end

  def create
    @bank_account = @character.bank_accounts.new(bank_account_params)
    authorize @bank_account

    if @bank_account.save
      redirect_to @bank_account, notice: 'BankAccount created successfully.'
    else
      render action: :new
    end
  end

  def update
    @bank_account = BankAccount.find_by id: params[:id]
    authorize @bank_account

    # Try updating transaction
    if params[:bank_transaction]
      @bank_account_transaction = @bank_account.outgoing_transactions.build(bank_transaction_params)
        if @bank_account_transaction.save
          redirect_to @bank_account, notice: 'Transaction posted successfully.'
        else
          flash[:notice] = "Something went wrong! Check your transaction log!"
          render action: :show
        end
    else # Try updating bank_account
      if @bank_account.update_attributes(bank_account_params)
        redirect_to @bank_account, notice: 'BankAccount updated successfully.'
      else
        render action: :show
      end
    end
  end

  def destroy
    #will lock/archive bank_account
  end

  private

  def bank_account_params
    params.require(:bank_account).permit! #aaahhhhhhhh
  end

  def bank_transaction_params
    params[:bank_transaction][:funds] = Money.new(params[:bank_transaction][:funds].to_f*100, params[:bank_transaction][:funds_currency])
    params[:bank_transaction][:from_account] = BankAccount.find_by id: params[:bank_transaction][:from_account] if params[:bank_transaction][:from_account]
    params[:bank_transaction][:to_account] = BankAccount.find_by id: params[:bank_transaction][:to_account] if params[:bank_transaction][:to_account]
    params.require(:bank_transaction).permit! #aaahhhhhhhh
  end

  def pundit_user
    @character
  end
end
