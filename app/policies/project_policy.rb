class ProjectPolicy
  attr_reader :actor, :project

  # Initialise actor and project to apply policy on
  def initialize(actor, project)
    @actor = actor
    @project = project
  end

  # Actors need to be admin for creating, updating or destroying resources
  # within projects

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

  # Get the role of current actor
  def currentActorRole
    if (Role.find_by_actor_id_and_project_id(actor.id, project.id)).nil?
      return "none"
    end
    return (RoleLevel.find((Role.find_by_actor_id_and_project_id(actor.id, project.id)).role_level_id)).name
  end
end
