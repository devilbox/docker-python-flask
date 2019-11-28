#!/bin/sh

set -e
set -u
set -x


###
### Default Variables
###
DEFAULT_FLASK_PORT=3000
DEFAULT_FLASK_APP="main.py"


# -------------------------------------------------------------------------------------------------
# Optional Environment variables
# -------------------------------------------------------------------------------------------------

###
### Custom listening port?
###
if env | grep '^FLASK_PORT=' >/dev/null; then
	DEFAULT_FLASK_PORT="$( env | grep '^FLASK_PORT=' | sed 's/^FLASK_PORT=//g' )"
fi


###
### Custom default file?
###
if env | grep '^FLASK_APP=' >/dev/null; then
	DEFAULT_FLASK_APP="$( env | grep '^FLASK_APP' | sed 's/^FLASK_APP=//g' )"
fi


###
### Adjust uid/gid
###
grep '^devilbox' /etc/group
sed -i'' "s|^devilbox:.*$|devilbox:x:${NEW_GID}:devilbox|g" /etc/group
grep '^devilbox' /etc/group

grep '^devilbox' /etc/passwd
sed -i'' "s|^devilbox:.*$|devilbox:x:${NEW_UID}:${NEW_GID}:Linux User,,,:/home/devilbox:/bin/ash|g" /etc/passwd
grep '^devilbox' /etc/passwd


# -------------------------------------------------------------------------------------------------
# Required Environment variables
# -------------------------------------------------------------------------------------------------

###
### Retrieve project directory
###
if ! env | grep '^FLASK_PROJECT=' >/dev/null; then
	>&2 echo "Error, FLASK_PROJECT variable not set."
	exit 1
fi
PROJECT="/shared/httpd/${FLASK_PROJECT}"


# -------------------------------------------------------------------------------------------------
# Validation
# -------------------------------------------------------------------------------------------------

###
### Check project directory
###
if [ ! -d "${PROJECT}" ]; then
	>&2 echo "Error, <project> directory does not exist: ${PROJECT}."
	exit 1
fi

###
### Check project/app directory
###
if [ ! -d "${PROJECT}/app" ]; then
	>&2 echo "Error, <project>/app directory does not exist: ${PROJECT}/app."
	exit 1
fi


###
### Check Entrypoint file
###
if [ ! -f "${PROJECT}/app/${DEFAULT_FLASK_APP}" ]; then
	>&2 echo "Error, <project>/app/${DEFAULT_FLASK_APP} entrypoint file does not exist: ${PROJECT}/app/${DEFAULT_FLASK_APP}."
	exit 1
fi


# -------------------------------------------------------------------------------------------------
# Entrypoint
# -------------------------------------------------------------------------------------------------

exec su -c "
	set -e
	set -u

	cd \"${PROJECT}\"

	if [ ! -d \"${PROJECT}/venv\" ]; then
		cd \"${PROJECT}\"
		virtualenv venv
	fi
	. venv/bin/activate

	if [ -f \"${PROJECT}/requirements.txt\" ]; then
		pip install -r \"${PROJECT}/requirements.txt\"
	fi

	cd \"${PROJECT}/app\"
	FLASK_ENV=development FLASK_APP=${DEFAULT_FLASK_APP} flask run --host=0.0.0.0 --port=${DEFAULT_FLASK_PORT}" devilbox
