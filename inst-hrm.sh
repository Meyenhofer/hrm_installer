#!/bin/bash

source funs.sh

echo "Downloading and extracting HRM."
wget -O /tmp/hrm-latest.tar.bz2 http://sourceforge.net/projects/hrm/files/latest/download

echo "Enter HRM installation directory (must be a sub-directory of Apache document root):"
hrmdir=`readstring "/var/www/hrm"`

hrm_user="hrm-user"
hrm_group="hrm"
echo "Creating HRM system user and group."
# create user and group on system
groupadd -r $hrm_group
useradd $hrm_user -r -g $hrm_group # --system --shell /bin/bash --no-create-home --ingroup $hrm_group
#usermod $hrm_user -aG $hrm_group
usermod www-data -aG $hrm_group

# create hrmdir and set permission
mkdir -vp $hrmdir
chown $hrm_user:$hrm_group $hrmdir
chmod u+s,g+ws $hrmdir

# extract hrm
tar xjvf /tmp/hrm-latest.tar.bz2 -C $hrmdir --strip-components=1
#errcheck "Could not download and extract HRM."

mkdir -vp /var/log/hrm
chown $hrm_user:$hrm_group /var/log/hrm
chmod u+s,g+ws /var/log/hrm
