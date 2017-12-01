class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    user.is_admin? or is_mine?
  end

  def new?
    create?
  end

  def update?
    user.is_admin? or is_mine?
  end

  def edit?
    update?
  end

  def destroy?
    user.is_admin? or is_mine?
  end

  # Metodo standard per controllare se il record mi appartiene
  def is_mine?
    if record.persisted?
      scope.exists?(record.id)
    else
      record.user_id==user.id
    end
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
