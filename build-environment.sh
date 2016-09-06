#!/bin/bash

if [ -z "$1" ]; then
    printf "You need to pass an environemnt type! \nE.G beta, local, test, pre-prod or remove (remove calls the docker-compose down and removed all containers).\nExiting from shell, Good bye!\n\n"
    exit 1;
fi

if [[ "$1" = "remove" ]];then
	docker-compose down
    exit 1;
fi	

if [[ "$1" != "test" ]]  &&  [[ "$1" != "pre-prod" ]] && [[ "$1" != "local" ]] && [[ "$1" != "develop"  ]];then
    printf "You need to pass a proper environemnt type! \nE.G develop, local, test or pre-prod.\nExiting from shell, Good bye!\n\n"
    exit 1;
fi

export ENV_TYPE=$1
BASE_DIR=""

export OS_TYPE=$(uname)

if [  "$OS_TYPE" = "Darwin" ]; then
	BASE_DIR="$HOME"
else
	BASE_DIR="/opt"
fi		

printf "Building docker containers for $1 environment\n"
printf "..................................................\n\n"
printf "If build is successfull, the following containers will be available:\n#Ubuntu 14.X\n#Apache as Reverse proxy\n#Tomcat on Oracle Jdk 8\n\n"

warLocation="./build-data/tomcat-webapps"
sqlDumpLocation="./build-data/sql-dumps/$ENV_TYPE"
warFile="$warLocation/ROOT.war"
sqlDump="$sqlDumpLocation/buzzmove_dump.sql" 

printf "Pre build steps - Looking for\n $warLocation \n$sqlDumpLocation \n$warFile \n$sqlDump\n\n"

if [ ! -f "$warFile" ]
then
	printf "WARN:You need to put the latest build (for the $1 environment) renamed as ROOT.war inside $warLocation for you to start accessing the this container!\n"
fi

# If there are war files rename it to respective war files
noOfWars="$(ls -l $warLocation/*.war | grep -v ^d | wc -l)"
if [ "$noOfWars" -eq 1 ]
	then
		printf "There is a war file - renaming it to ROOT.war\n"
		$(mv $warLocation/*.war $warFile)
fi	

# If there are sql dumps files rename it to respective sql files
noOfDumps="$(ls -l $sqlDumpLocation/*.sql | grep -v ^d | wc -l)"
if [ "$noOfDumps" -eq 1 ]
	then
		printf "There is a sql dump file - renaming it to buzzmove_dump.sql\n"
		$(mv $sqlDumpLocation/*.sql $sqlDump)
fi	


if [ ! -f "$sqlDump" ]
then
	printf "WARN:You need to put the sql dump  (for the $1 environment) with the file name as buzzmove_dump.sql inside $sqlDumpLocation for you to start accessing the this container!"
fi

printf "Building $ENV_TYPE environment \n"

# call the corresponding scripts based on environments

if [  "$ENV_TYPE" = "local" ]; then
	  export ROOT_DIR="$HOME/buzzmove-docker"
	./build-local-environment.sh
else
	  export ROOT_DIR="$BASE_DIR/buzzmove-docker"
	./build-aws-environment.sh
fi	


printf "Setting permissions and environments..."
chmod -R 755 $ROOT_DIR

# Set mysql env variables to be passed to docker compose
export ENV_MYSQL_ROOT_PWD='lqsbd172'
export ENV_MYSQL_DATABSE='buzzmove'
export ENV_MYSQL_USER='buzzmove'
export ENV_MYSQL_PWD='bu55m0v3'

printf "[OK] \n"
printf "Excellent! All pre-build steps complete. About to call the docker-compose to build the images. Have a coffee and when your back, all should be done!\n\n"

docker-compose up -d