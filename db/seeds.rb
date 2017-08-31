# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

actor = Actor.create(email: "superadmin@hotmail.com", fullname: "SuperAdmin")
project = Project.create(name: "SuperProject", description: "A super test Project")
role = Role.create(project_id: project.id, actor_id: actor.id, role_level_id: 1)
