#!/bin/bash

echo "Welcome to the HRM installation script."

source funs.sh

echo "Looking for hucore installation."
hucorepath=`which hucore`
[ -z  "$hucorepath" ] && abort "Hucore could not be found."

source inst-pkgs.sh

if [ "$dbtype" == "m" ];
then
	source conf-mysql.sh
	dbtype="mysql"
elif [ "$dbtype" == "p" ]
then
	source conf-pgsql.sh
	dbtype="postgres"
fi

source inst-hrm.sh
source conf-hrm.sh
source conf-php.sh
source make-db.sh
source conf-qm.sh
source perms.sh

echo "Please restart apache and change the default admin password 'pwd4hrm'."