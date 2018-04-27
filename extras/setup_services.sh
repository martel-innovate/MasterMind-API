#! /ur/bin/env bash

# This is a basic example script for bringing up some services using the Mastermind
# API via the mm.py client.
# 
# WARNING - it is a bit brittle as it really requires a clean swarm cluster to which
# Mastermind is talking.
#
# It is assumed that the Mastermind API is configured such that OAuth is disabled and
# hence there is not a FIWARE OAuth flow.

MASTERMIND_API="http://localhost:3000"

AUTH_TOKEN=$(curl -s "$MASTERMIND_API/auth/token?code=1" | jq -r '.auth_token')

echo
echo "*** Creating project..."
./mm.py project-create $AUTH_TOKEN TestProject 'A Test Project'

echo
echo "*** Listing projects..."
./mm.py project-list $AUTH_TOKEN

echo
echo "*** Creating cluster..."
./mm.py cluster-create $AUTH_TOKEN 2 'TestCluster' 'A Test cluster' 'tcp://160.85.2.17:2376' ./cert.pem ./ca.pem ./key.pem 

echo
echo "*** Listing clusters..."
./mm.py cluster-list $AUTH_TOKEN 2

echo
echo "*** Listing service types..."
./mm.py servicetype-list

echo
echo "*** Creating mongo service..."
./mm.py service-create $AUTH_TOKEN 2 'mongo' ./mongo.conf 'Active' 'true' 'endpoint' '0.0' '0.0' 3 'abc' '1'

echo
echo "*** Creating orion service..."
./mm.py service-create $AUTH_TOKEN 2 'orion' ./orion.conf 'Active' 'true' 'endpoint' '0.0' '0.0' 6 'abc' '1'

echo
echo "*** Creating iotagent service..."
./mm.py service-create $AUTH_TOKEN 2 'iotagent' ./iotagent.conf 'Active' 'true' 'endpoint' '0.0' '0.0' 7 'abc' '1'

echo
echo "*** Listing service..."
./mm.py service-list $AUTH_TOKEN 2

sleep 5

echo
echo "*** Deploying mongo service..."
./mm.py deploy-service $AUTH_TOKEN 2 1 1 'mongo' 

echo
echo "*** Deploying orion service..."
./mm.py deploy-service $AUTH_TOKEN 2 1 2 'orion' 

echo
echo "*** Deploying iotagent service..."
./mm.py deploy-service $AUTH_TOKEN 2 1 3 'iotagent' 
