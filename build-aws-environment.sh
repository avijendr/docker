#!/bin/bash

printf "Creating necessary directory structures (existing directories will be removed and recreated)..."

if [ -d "$ROOT_DIR" ]; then
    if [  "$OS_TYPE" = "Darwin" ]; then
		rm -rf $ROOT_DIR
	else
		sudo rm -rf $ROOT_DIR
	fi     
fi

if [  "$OS_TYPE" = "Darwin" ]; then
   mkdir $ROOT_DIR
else
   sudo mkdir $ROOT_DIR 
   sudo chown ec2-user:ec2-user $ROOT_DIR -R 
fi     

mkdir  $ROOT_DIR/host-data
mkdir  $ROOT_DIR/host-data/apache
mkdir  $ROOT_DIR/host-data/apache/conf
mkdir  $ROOT_DIR/host-data/apache/logs
mkdir  $ROOT_DIR/host-data/apache/certs
mkdir  $ROOT_DIR/host-data/tomcat
mkdir  $ROOT_DIR/host-data/tomcat/webapps
mkdir  $ROOT_DIR/host-data/tomcat/logs
mkdir  $ROOT_DIR/host-data/tomcat/logs/backup
mkdir  $ROOT_DIR/host-data/sql-dumps

printf "[OK] \n"
printf "Copying necessary files..."

cp ./build-data/apache/$ENV_TYPE/000-default.conf $ROOT_DIR/host-data/apache/conf
cp ./build-data/apache/$ENV_TYPE/Domain.crt $ROOT_DIR/host-data/apache/certs
cp ./build-data/apache/$ENV_TYPE/Intermediate.pem $ROOT_DIR/host-data/apache/certs
cp ./build-data/apache/$ENV_TYPE/Domain.key $ROOT_DIR/host-data/apache/certs

cp ./build-data/sql-dumps/$ENV_TYPE/db_dump.sql $ROOT_DIR//host-data/sql-dumps

# TODO Make a meven build based on environments and copy the war into this folder
cp ./build-data/tomcat-webapps/ROOT.war $ROOT_DIR/host-data/tomcat/webapps

printf "[OK] \n"

