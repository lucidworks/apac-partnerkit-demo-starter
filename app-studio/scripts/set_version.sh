#!/bin/bash
set -xeuo pipefail

# $1: path to directory containing package.json
# $2: version to set
updateNpm() {
	echo "Setting NPM version to ${2}"

	if ! npm --prefix="${1}" --no-git-tag-version version "${2}"; then
		echo "Failed to update NPM.  Working copy may be dirty."
		exit 2
	else
	echo "Adding ${1}/package.json to Git"
		git add "${1}/package.json"
	fi
}

# $1: path to directory containing pom.xml
# $2: version to set
updateMaven() {
	echo "Setting Maven version to ${2}"

	if ! mvn -f "${1}"/pom.xml versions:set -DnewVersion="${2}" -DgenerateBackupPoms=false; then
		echo "Failed to update Maven.  Working copy may be dirty."
		exit 1
	else
		echo "Adding ${1}/pom.xml to Git"
		git add "${1}/pom.xml"
	fi
}

# Script begins
if [ "$1" = "" ]; then
	echo Usage: set_version VERSION_NUMBER
else
	# Get path of script
	SCRIPT_LOCATION=$(dirname "${BASH_SOURCE[0]}")
	BASEDIR="${SCRIPT_LOCATION}/.."

	echo "Setting new version ${1}"

	updateNpm "${BASEDIR}" "${1}"
	updateMaven "${BASEDIR}" "${1}"

	# Add to Git
	if [[ "${1}" =~ SNAPSHOT$ ]]; then
		git commit -m "Start work on ${1}"
	else
		git commit -m "Release version ${1}"
		git tag -a "${1}" -m "Release version ${1}"
	fi
fi
