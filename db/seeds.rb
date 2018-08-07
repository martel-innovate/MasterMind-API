# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'find'

# Initialising database with service types from Catalog repo
if (Dir["mastermind-services"]).length == 0 then
  `git clone https://github.com/martel-innovate/MasterMind-Service-Catalog mastermind-services`
end

Find.find('mastermind-services') do |path|
  if path =~ /.*mastermind\.yml$/
    directory = File.dirname(path)
    mastermindConf = YAML::load(File.open(directory+'/mastermind.yml'))
    dockerCompose = YAML::load(File.open(directory+'/docker-compose.yml'))
    ServiceType.create(local_path: directory, name: mastermindConf["name"], description: mastermindConf["description"], version: mastermindConf["version"], service_protocol_type: mastermindConf["protocol_type"], ngsi_version: mastermindConf["ngsi_version"], configuration_template: File.read(directory+'/mastermind.yml'), deploy_template: File.read(directory+'/docker-compose.yml'))
  end
end

# Initialising database with role levels
adminLevel = RoleLevel.find_by(name: "admin")
if adminLevel.nil? then
  RoleLevel.create(name: "admin")
end
userLevel = RoleLevel.find_by(name: "user")
if userLevel.nil? then
  RoleLevel.create(name: "user")
end
superAdminLevel = RoleLevel.find_by(name: "superadmin")
if superAdminLevel.nil? then
  RoleLevel.create(name: "superadmin")
end

# Setting test superadmin
actor = Actor.create(email: "superadmintest@gmail.com", fullname: "superadmintest", superadmin: true)
project = Project.create(name: "SuperProject", description: "A super test Project")
project.roles.create!(actor_id: actor.id, role_level_id: 1, clusters_permissions: true, services_permissions: true, subscriptions_permissions: true)
