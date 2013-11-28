function abort()
{
        echo -e "$1\nAborting HRM installation."
        exit 1
}

function errcheck()
{
        [ $? ] && abort "$1"
}

function packages_missing() {
    # Check the debian dpkg database for one or more packages to ensure they
    # are installed on the system. Returns the name of all packages that don't
    # have the dpkg status "installed".
    unset PKGSMISSING
    for PKG in $* ; do
        # the only "valid" status that we can check for is "installed", which
        # is printed at the line-end by dpkg:
        if ! dpkg --get-selections $PKG 2>&1 | grep -q 'install$' ; then
            PKGSMISSING="$PKGSMISSING $PKG"
        fi
    done
    echo $PKGSMISSING
}

function install_packages()
{
        aptitude install "$1"
}

function readkey() {
    # Read a single keypress and return it as lower-case.
    read -p '> ' -n 1
    echo $REPLY | tr '[A-Z]' '[a-z]'
}

function readstring() {
    # Show a preset string that can be changed or accepted.
    # Do not accept empty return values.
    while [ -z "$REPLY" ] ; do
        read -p '> ' -e -i "$1"
    done
    echo $REPLY
}

function waitconfirm() {
    # Display a message and wait for the user to confirm by pressing 'y'.
    echo "Press [y] to continue, [Ctrl]-[C] to abort."
    while ! [ "$(readkey)" == "y" ] ; do
        echo
    done
}

function mysqlcmd()
{
	mysql -h localhost -u $1 -p$2 -e "$3"
}

function pgsqlcmd()
{
	su postgres -c "psql -c \"$1\""
}

function sedconf()
{
	sed -i -e "s|$2|$3|" "$1"
}
