#!/bin/bash
set -euo pipefail
set -x

TOP_DIR="$(cd "$(dirname "${BASH_SOURCE-$0}")/.."; /bin/pwd)"

mvn -T 4 clean install --settings ./bin/settings.xml --batch-mode

# Set up some variables
POM_VERSION=$(grep -m 1 -E '<version>' ./pom.xml | sed -E 's/<version>(.*)<\/version>/\1/' | tr -d ' ')
ZIP_NAME="dist/app-studio-enterprise-${POM_VERSION}.zip"

# Package the app into a zip file, excluding certain directories
echo "Packaging zip file ${ZIP_NAME}"
zip -r "${ZIP_NAME}" . \
-x \
 .idea/\* \
 .git/\* \
 .travis.yml \
 \*.log \
 dist/\* \
 jenkins/\* \
 logs/\* \
 m2/\* \
 node_modules/\* \
 publish/\* \
 scripts/\* \
 target/\*

