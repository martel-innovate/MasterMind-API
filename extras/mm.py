#! /usr/bin/env python3

# This is a basic Mastermind command line interface. It provides a way to
# work with the Mastermind interface which is more high level (and somewhat
# easier to use) than a curl based interface.
#
# It is not very flexible in its current incarnation; it does not provide full
# coverage of the Mastermind API, nor does it do sufficient data validation.
#

import click
import requests
import json

MM_BASE='http://localhost:3000/'

@click.group()
@click.option('--debug/--no-debug', default=False)
def cli(debug):
	pass


@cli.command()
def version():
	version_endpoint = MM_BASE + 'version'
	r = requests.get(version_endpoint)
	response = json.loads(r.text)
	print("Version {} of Mastermind running on {}".format(response['version'], MM_BASE) )


@cli.command('project-list')
@click.argument('auth-token')
def project_list(auth_token):
	project_endpoint = MM_BASE + 'v1/projects/'
	headers = {'Authorization': auth_token }
	r = requests.get(project_endpoint, headers=headers)
	response = json.loads(r.text)
	if len(response) == 0:
		print("No projects defined.")
	else:
		for project in response:
			print("ID: {}, Name: {}, Description: {}".format(project['id'], project['name'], project['description']))


@cli.command('project-create')
@click.argument('auth-token')
@click.argument('name')
@click.argument('description')
def project_create(auth_token, name, description):
	project_endpoint = MM_BASE + 'v1/projects/'
	headers = {'Authorization': auth_token }
	payload = {'name': name, 'description': description }
	r = requests.post(project_endpoint, headers=headers, data=payload)
	response = json.loads(r.text)
	if r.status_code == 201:
		# success
		print("Project {} successfully created".format(name) )
	else:
		print("Error creating project - response code: {}".format(r.status_code))


@cli.command('cluster-list')
@click.argument('auth-token')
@click.argument('project', type=click.INT)
def cluster_list(auth_token, project):
	cluster_endpoint = MM_BASE + 'v1/projects/' + str(project) + '/clusters/'
	headers = {'Authorization': auth_token }
	r = requests.get(cluster_endpoint, headers=headers)
	response = json.loads(r.text)
	if len(response) == 0:
		print("No clusters defined in project with ID {}".format(project))
	else:
		print("Clusters defined in project with ID {}".format(project))
		for cluster in response:
			print("ID: {}, Name: {}, Description: {}".format(cluster['id'], cluster['name'], cluster['description']))


@cli.command('cluster-create')
@click.argument('auth-token')
@click.argument('project', type=click.INT)
@click.argument('name')
@click.argument('description')
@click.argument('endpoint')
@click.argument('cert', type=click.File('r'))
@click.argument('ca', type=click.File('r'))
@click.argument('key', type=click.File('r'))
def cluster_create(auth_token, project, name, description, endpoint, cert, ca, key):
	cluster_endpoint = MM_BASE + 'v1/projects/' + str(project) + '/clusters/'
	headers = {'Authorization': auth_token }
	payload = { 'name': name, 
			    'description': description,
			    'endpoint': endpoint,
			    'cert': cert.read(),
			    'ca': ca.read(),
			    'key': key.read() }
	r = requests.post(cluster_endpoint, headers=headers, data=payload)
	response = json.loads(r.text)
	if r.status_code == 201:
		# success
		print("Cluster {} successfully created".format(name) )
	else:
		print("Error creating cluster - response code: {}".format(r.status_code))


@cli.command('servicetype-list')
def servicetype_list():
	servicetype_endpoint = MM_BASE + 'v1/service_types/'
	r = requests.get(servicetype_endpoint)
	response = json.loads(r.text)
	if len(response) == 0:
		print("No service types defined in Mastermind.")
	else:
		print("Service Types defined in Mastermind")
		for servicetype in response:
			print("ID: {}, Name: {}, Version: {}".format(servicetype['id'], servicetype['name'], servicetype['version']))


@cli.command('service-list')
@click.argument('auth-token')
@click.argument('project', type=click.INT)
def service_list(auth_token, project):
	service_endpoint = MM_BASE + 'v1/projects/' + str(project) + '/services/'
	headers = {'Authorization': auth_token }
	r = requests.get(service_endpoint, headers=headers)
	response = json.loads(r.text)
	if len(response) == 0:
		print("No services defined for project {}".format(project))
	else:
		print("Services defined for project {}".format(project))
		for service in response:
			print("ID: {}, Name: {}, Status: {}".format(service['id'], service['name'], service['status']))


@cli.command('service-create')
@click.argument('auth-token')
@click.argument('project', type=click.INT)
@click.argument('name')
@click.argument('configuration', type=click.File('r'))
@click.argument('status')
@click.argument('managed', type=click.BOOL)
@click.argument('endpoint')
@click.argument('latitude')
@click.argument('longitude')
@click.argument('service_type_id', type=click.INT)
@click.argument('docker_service_id')
@click.argument('cluster_id')
def service_create(auth_token, project, name, configuration, status, managed, endpoint, 
				   latitude, longitude, service_type_id, docker_service_id, cluster_id):
	service_endpoint = MM_BASE + 'v1/projects/' + str(project) + '/services/'
	headers = {'Authorization': auth_token }
	conf = configuration.read()
	payload = { 'name': name,
			    'configuration': conf,
			    'status': status,
			    'managed': managed,
			    'endpoint': endpoint,
			    'latitude': latitude,
			    'longitude': longitude,
			    'service_type_id': service_type_id,
			    'docker_service_id': docker_service_id,
			    'cluster_id': cluster_id
			   }
	r = requests.post(service_endpoint, headers=headers, data=payload)
	response = json.loads(r.text)
	if r.status_code == 201:
		# success
		print("Cluster {} successfully created".format(name) )
	else:
		print("Error creating cluster - response code: {}".format(r.status_code))


@cli.command('deploy-service')
@click.argument('auth-token')
@click.argument('project', type=click.INT)
# this is the cluster id
@click.argument('id', type=click.INT)
@click.argument('service-id')
@click.argument('service-name')
def deploy_service(auth_token, project, id, service_id, service_name ):
	deploy_endpoint = MM_BASE + 'v1/projects/' + str(project) + '/clusters/' + str(id) + '/deploy'
	headers = {'Authorization': auth_token }
	# conf = configuration.read()
	payload = { 'service_id': service_id,
			    'service_name': service_name
			  }
	r = requests.get(deploy_endpoint, headers=headers, data=payload)
	response = json.loads(r.text)
	if r.status_code == 201:
		# success
		print("Service {} successfully deployed".format(service_name) )
	else:
		print("Error deploying service - response code: {}".format(r.status_code))


if __name__ == '__main__':
    cli()