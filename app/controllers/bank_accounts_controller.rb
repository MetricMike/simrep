class BankAccountsController < ApplicationController
  before_action :authenticate_user!

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @group_bank_accounts = policy_scope(GroupBankAccount)
    @personal_bank_accounts = policy_scope(PersonalBankAccount)
  end

  def show
    @bank_account = BankAccount.find(params[:id])
    authorize @bank_account

    @transactions = @bank_account.transactions
    @items = @bank_account.items.latest
    @bank_account_transaction = @bank_account.outgoing_transactions.build()
  end

  def print
    @bank_account = BankAccount.find(params[:id])
    authorize @bank_account

    @transactions = @bank_account.transactions.limit(10)
    @items = @bank_account.incoming_items.latest

    render layout: 'pdf.html.erb'
  end

  def new
    @bank_account = current_character.bank_accounts_personal.new
    authorize @bank_account
  end

  # def edit
  #   Same-page rendering done in #show
  # end

  def create
    @bank_account = current_character.bank_accounts_personal_accounts.new(bank_account_params)
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
          flash[:notice] = "Transaction failed with the following error: #{@bank_account_transaction.errors.messages}"
          render action: :show
        end
    # Currently no reason to update a bank_account from this controller. Eventually, access grants will probably go through here.
    #else
    #  if @bank_account.update_attributes(bank_account_params)
    #    redirect_to @bank_account, notice: 'BankAccount updated successfully.'
    #  else
    #    render action: :show
    #  end
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
    params[:bank_transaction][:from_account] = BankAccount.find(id: params[:bank_transaction][:from_account]) if params[:bank_transaction][:from_account]
    params[:bank_transaction][:to_account] = BankAccount.find(id: params[:bank_transaction][:to_account]) if params[:bank_transaction][:to_account]
    params.require(:bank_transaction).permit! #aaahhhhhhhh
  end

end
