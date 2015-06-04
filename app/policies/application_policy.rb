class ApplicationPolicy
  attr_reader :user, :character, :record

  def initialize(context, record)
    raise Pundit::NotAuthorizedError, "must be signed in" unless context.user
    @user = context.user
    @character = context.character
    @record = record
  end

  def has_control?
    @user.admin?
  end

  def has_access?
    has_control?
  end

  def index?  ; false;        end
  def show?   ; has_access?;  end
  def new?    ; create?;      end
  def create? ; has_control?; end
  def edit?   ; update?;      end
  def update? ; has_control?; end
  def destroy?; has_control?; end

  def scope
    Pundit.policy_scope!(context, record.class)
  end

  class Scope
    attr_reader :user, :character, :scope

    def initialize(context, scope)
      @user = context.user
      @character = context.character
      @scope = scope
    end

    def resolve
      @user.admin? ? scope.all : @character.scope
    end
  end

end

