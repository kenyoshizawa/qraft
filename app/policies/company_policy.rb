class CompanyPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def show?
    user.company_id == record.id
  end

  def new?
    user.admin? && user.company_id.nil?
  end

  def create?
    new?
  end

  def edit?
    user.admin? && user.company_id == record.id
  end

  def update?
    edit?
  end

  def show_navigation_link?
    user.general? && show?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
