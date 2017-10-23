# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Initialising database with service types
if (Dir["mastermind-services"]).length == 0 then
  `git clone https://github.com/martel-innovate/MasterMind-Service-Catalog mastermind-services`
for path in Dir['mastermind-services/*/']
  mastermindConf = YAML::load(File.open(path+'mastermind.yml'))
  dockerCompose = YAML::load(File.open(path+'docker-compose.yml'))
  serviceType = ServiceType.find_by(name: mastermindConf["name"])
  if serviceType.nil? then
    ServiceType.create(name: mastermindConf["name"], service_protocol_type: mastermindConf["protocol_type"], ngsi_version: mastermindConf["ngsi_version"], configuration_template: File.read(path+'mastermind.yml'), deploy_template: File.read(path+'docker-compose.yml'))
  end
end
# Initialising database with role levels
adminLevel = RoleLevel.find_by(name: "admin")
if adminLevel.nil? then
  RoleLevel.create(name: "admin")
end
userLevel = RoleLevel.find_by(name: "user")
if adminLevel.nil? then
  RoleLevel.create(name: "user")
end

# Some temporary mock data
actor = Actor.create(email: "superadmin@hotmail.com", fullname: "SuperAdmin")
project = Project.create(name: "SuperProject", description: "A super test Project")
role = Role.create(project_id: project.id, actor_id: actor.id, role_level_id: 1)
