class ProjectPolicy
  attr_reader :actor, :project

  def initialize(actor, project)
    @actor = actor
    @project = project
  end

  def index?
    currentActorRole() == "user" or currentActorRole() == "admin" or actor.superadmin
  end

  def show?
    currentActorRole() == "user" or currentActorRole() == "admin" or actor.superadmin
  end

  def create?
    currentActorRole() == "admin" or actor.superadmin
  end

  def update?
    currentActorRole() == "admin" or actor.superadmin
  end

  def destroy?
    currentActorRole() == "admin" or actor.superadmin
  end

  def currentActorRole
    if (Role.find_by_actor_id_and_project_id(actor.id, project.id)).nil?
      return "none"
    end
    return (RoleLevel.find((Role.find_by_actor_id_and_project_id(actor.id, project.id)).role_level_id)).name
  end
end
