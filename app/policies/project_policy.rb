class ProjectPolicy
  attr_reader :actor, :project

  def initialize(actor, project)
    @actor = actor
    @project = project
  end

  def index?
    currentActorRole() == "user" or currentActorRole() == "admin"
  end

  def show?
    currentActorRole() == "user" or currentActorRole() == "admin"
  end

  def create?
    currentActorRole() == "admin"
  end

  def update?
    currentActorRole() == "admin"
  end

  def destroy?
    currentActorRole() == "admin"
  end

  def currentActorRole
    return (RoleLevel.find((Role.find_by_actor_id_and_project_id(actor.id, project.id)).role_level_id)).name
  end
end
