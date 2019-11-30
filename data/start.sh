#!/bin/sh

set -e
set -u


###
### Default Variables
###
DEFAULT_FLASK_PORT=3000
DEFAULT_FLASK_APP_DIR="app"
DEFAULT_FLASK_APP_FILE="main.py"
DEFAULT_NEW_UID=1000
DEFAULT_NEW_GID=1000


# -------------------------------------------------------------------------------------------------
# Required Environment variables
# -------------------------------------------------------------------------------------------------

###
### Retrieve project directory
###
if ! env | grep '^FLASK_PROJECT=' >/dev/null; then
	>&2 echo "[ERR]  FLASK_PROJECT variable not set"
	exit 1
fi
echo "[INFO] Setting internal project dir to: /shared/httpd/${FLASK_PROJECT}"
PROJECT="/shared/httpd/${FLASK_PROJECT}"


# -------------------------------------------------------------------------------------------------
# Optional Environment variables
# -------------------------------------------------------------------------------------------------

###
### Custom listening port?
###
if ! env | grep '^FLASK_PORT=' >/dev/null; then
	echo "[INFO] Keeping internal Flask port at default: ${DEFAULT_FLASK_PORT}"
else
	echo "[INFO] Setting internal Flask port to: ${FLASK_PORT}"
	DEFAULT_FLASK_PORT="${FLASK_PORT}"
fi


###
### Custom default dir?
###
if ! env | grep '^FLASK_APP_DIR=' >/dev/null; then
	echo "[INFO] Keeping FLASK_APP_DIR at default: ${DEFAULT_FLASK_APP_DIR}"
else
	echo "[INFO] Setting FLASK_APP_DIR to: ${FLASK_APP_DIR}"
	DEFAULT_FLASK_APP_DIR="${FLASK_APP_DIR}"
fi


###
### Custom default file?
###
if ! env | grep '^FLASK_APP_FILE=' >/dev/null; then
	echo "[INFO] Keeping FLASK_APP_FILE at default: ${DEFAULT_FLASK_APP_FILE}"
else
	echo "[INFO] Setting FLASK_APP_FILE to: ${FLASK_APP_FILE}"
	DEFAULT_FLASK_APP_FILE="${FLASK_APP_FILE}"
fi


###
### Adjust uid/gid
###
if ! env | grep '^NEW_UID=' >/dev/null; then
	echo "[INFO] Keeping NEW_UID at default: ${DEFAULT_NEW_UID}"
else
	echo "[INFO] Setting NEW_UID to: ${NEW_UID}"
	DEFAULT_NEW_UID="${NEW_UID}"
fi

if ! env | grep '^NEW_GID=' >/dev/null; then
	echo "[INFO] Keeping NEW_GID at default: ${DEFAULT_NEW_GID}"
else
	echo "[INFO] Setting NEW_GID to: ${NEW_GID}"
	DEFAULT_NEW_GID="${NEW_GID}"
fi

sed -i'' "s|^devilbox:.*$|devilbox:x:${DEFAULT_NEW_GID}:devilbox|g" /etc/group
ETC_GROUP="$( grep '^devilbox' /etc/group )"
echo "[INFO] /etc/group: ${ETC_GROUP}"

sed -i'' "s|^devilbox:.*$|devilbox:x:${DEFAULT_NEW_UID}:${DEFAULT_NEW_GID}:Linux User,,,:/home/devilbox:/bin/ash|g" /etc/passwd
ETC_PASSWD="$( grep '^devilbox' /etc/passwd )"
echo "[INFO] /etc/passwd: ${ETC_PASSWD}"

chown "${DEFAULT_NEW_UID}:${DEFAULT_NEW_GID}" /home/devilbox
chown "${DEFAULT_NEW_UID}:${DEFAULT_NEW_GID}" /shared/httpd
PERM_HOME="$( ls -ld /home/devilbox )"
PERM_DATA="$( ls -ld /shared/httpd )"
echo "[INFO] ${PERM_HOME}"
echo "[INFO] ${PERM_DATA}"


# -------------------------------------------------------------------------------------------------
# Validation
# -------------------------------------------------------------------------------------------------

##
## Check project directory
##
if [ ! -d "${PROJECT}" ]; then
	>&2 echo "[WARN] <project> directory does not exist: ${PROJECT}"
fi

###
### Check project/app directory
###
if [ ! -d "${PROJECT}/${DEFAULT_FLASK_APP_DIR}" ]; then
	>&2 echo "[WARN] <project>/${DEFAULT_FLASK_APP_DIR} directory does not exist: ${PROJECT}/${DEFAULT_FLASK_APP_DIR}"
fi


###
### Check Entrypoint file
###
if [ ! -f "${PROJECT}/${DEFAULT_FLASK_APP_DIR}/${DEFAULT_FLASK_APP_FILE}" ]; then
	>&2 echo "[WARN] <project>/${DEFAULT_FLASK_APP_DIR}/${DEFAULT_FLASK_APP_FILE} entrypoint file does not exist: ${PROJECT}/${DEFAULT_FLASK_APP_DIR}/${DEFAULT_FLASK_APP_FILE}"
fi


# -------------------------------------------------------------------------------------------------
# Entrypoint
# -------------------------------------------------------------------------------------------------

exec su -c "
	set -e
	set -u

	if [ ! -d \"${PROJECT}\" ]; then
		echo \"[INFO] Creating project directory: ${PROJECT}\"
		mkdir -p \"${PROJECT}\"
	fi

	cd \"${PROJECT}\"
	if [ ! -d \"${PROJECT}/venv\" ]; then
		echo \"[INFO] Creating Python virtual env: ${PROJECT}/venv\"
		virtualenv venv
	fi
	. venv/bin/activate

	if [ ! -f \"${PROJECT}/requirements.txt\" ]; then
		echo \"[INFO] No requirements.txt file found at: ${PROJECT}/requirements.txt\"
	else
		echo \"[INFO] Installing pip requirements from: ${PROJECT}/requirements.txt\"
		pip install -r \"${PROJECT}/requirements.txt\"
	fi

	if [ ! -d \"${PROJECT}/${DEFAULT_FLASK_APP_DIR}\" ]; then
		echo \"[INFO] Creating project app directory: ${PROJECT}/${DEFAULT_FLASK_APP_DIR}\"
		mkdir -p \"${PROJECT}/${DEFAULT_FLASK_APP_DIR}\"
	fi

	flask --version

	cd \"${PROJECT}/${DEFAULT_FLASK_APP_DIR}\"
	FLASK_ENV=development FLASK_APP=${DEFAULT_FLASK_APP_FILE} flask run --host=0.0.0.0 --port=${DEFAULT_FLASK_PORT}" devilbox
