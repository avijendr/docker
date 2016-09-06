#!/bin/bash

printf "Creating necessary directory structures (existing directories will be removed and recreated)..."

if [ -d "$ROOT_DIR" ]; then
     rm -rf $ROOT_DIR     
fi

mkdir $ROOT_DIR 

# TODO this redudant code should be inside the build sctripo s this is duplicating
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
cp ./build-data/apache/$ENV_TYPE/buzzmoveNonProdDomain.crt $ROOT_DIR/host-data/apache/certs
cp ./build-data/apache/$ENV_TYPE/buzzmoveNonProdIntermediate.pem $ROOT_DIR/host-data/apache/certs
cp ./build-data/apache/$ENV_TYPE/buzzmoveNonProdDomain.key $ROOT_DIR/host-data/apache/certs

cp ./build-data/sql-dumps/$ENV_TYPE/buzzmove_dump.sql $ROOT_DIR/host-data/sql-dumps

# TODO Make a meven build based on environments and copy the war into this folder
cp ./build-data/tomcat-webapps/ROOT.war $ROOT_DIR/host-data/tomcat/webapps

printf "[OK] \n"