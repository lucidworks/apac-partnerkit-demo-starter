#!/bin/bash
set -xeuo pipefail

APPKIT_UI_URL_BASE="http://appkit.lucidworks.com/repo"
APPKIT_UI_TARBALL="appkit-ui.tar.gz"
APPKIT_UI_PACKAGE="appkit-ui"

# $1 directory containing package.json
# $2 version
updateNpm() {
	echo "NPM upgrading ${1}/package.json to use Appkit ${2}"

	if ! npm --prefix="${1}" install "${APPKIT_UI_PACKAGE}" "${APPKIT_UI_URL_BASE}/${2}/${APPKIT_UI_TARBALL}" --save; then
		echo "Failed to update NPM.  Working copy may be dirty."
		exit 2
	else
		echo "Adding ${1}/package.json to Git"
		git add "${1}/package.json"
	fi
}

# $1 directory containing pom.xml
# $2 version
updateMaven() {
	echo "Maven upgrading ${1}/pom.xml to use Appkit ${2}"

	if ! mvn -f "${1}" versions:update-parent -DallowSnapshots=true "-DparentVersion=[${2}]" -DgenerateBackupPoms=false; then
		echo "Failed to update Maven.  Working copy may be dirty."
		exit 1
	else
		echo "Adding ${1}/pom.xml to Git"
		git add "${1}/pom.xml"
	fi
}

# Script begins
if [ "$1" = "" ]; then
	echo Usage: update_appkit.sh VERSION_NUMBER
else
# Get path of script
	SCRIPT_LOCATION=$(dirname "${BASH_SOURCE[0]}")
	BASEDIR="${SCRIPT_LOCATION}/.."

	mvn -f "${BASEDIR}" clean

	updateNpm "${BASEDIR}" "$1"
	updateMaven "${BASEDIR}" "$1"

	# Add to Git
	git commit -m "Use Appkit ${1}"
fi

