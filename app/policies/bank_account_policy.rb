class BankAccountPolicy < ApplicationPolicy
  attr_reader :character, :bank_account

  def initialize(character, bank_account)
    @character = character
    @bank_account = bank_account
  end

  def owned?
    @character.user.admin? or @bank_account.owner == @character
  end

  def show?
    owned?
  end

  def create?
    @character.present?
  end

  def update?
    owned?
  end

  def destroy?
    @character.user.admin? or owned?
  end

  class Scope < Scope
    attr_reader :character, :bank_account

    def initialize(character, bank_account)
      @character = character
      @bank_account = bank_account
    end

    def resolve
      if @character.user.admin?
        @bank_account.all
      else
        @character.bank_accounts
      end
    end
  end
end
