#!/bin/bash
set -euo pipefail
set -x

TOP_DIR="$(cd "$(dirname "${BASH_SOURCE-$0}")/.."; /bin/pwd)"
cd "$TOP_DIR"

# Deploy built artifact to Nexus via Maven Deploy plugin

## Parse out versions
POM_VERSION=$(grep -E '<version>' ./pom.xml | head -n 1 | sed -E 's/<version>(.*)<\/version>/\1/'|tr -d ' ')
POM_ARTIFACT_ID=$(grep -E '<artifactId>' ./pom.xml | head -n 1 | sed -E 's/<artifactId>(.*)<\/artifactId>/\1/'|tr -d ' ')

if grep -E -q SNAPSHOT <<<"$POM_VERSION"; then
  REPO=snapshots
else
  REPO=releases
fi

## Configure Maven
MAVEN_LW_REPO_ID=lucidworks.nexus

if [[ -z "${MVN_TWIGKIT_PROFILE:-}" ]]; then
  # When running on Jenkins, this will be passed in as a secret file (see the Jenkinsfile)
  # If you want to run this locally, copy the profile to the project root
  # Make sure it has a "lucidworks.nexus" server section
  MVN_TWIGKIT_PROFILE="$TOP_DIR/twigkit-profile.xml"
fi

if ! grep "<id>$MAVEN_LW_REPO_ID</id>" "$MVN_TWIGKIT_PROFILE"; then
  cat <<EOM
$MVN_TWIGKIT_PROFILE is missing a lucidworks.nexus server section:
      <server>
      <id>$MAVEN_LW_REPO_ID</id>
      <username>jenkins</username>
      <password>PASSWORD_HERE</password>
    </server>
EOM
fi

## Deploy to Nexus
mvn -s "$MVN_TWIGKIT_PROFILE" \
  deploy:deploy-file -Durl="https://ci-nexus.lucidworks.com/content/repositories/$REPO" \
    -DrepositoryId="$MAVEN_LW_REPO_ID" \
    -Dfile="app-studio-ide/dist/$POM_ARTIFACT_ID-$POM_VERSION.war" \
    -DgroupId=com.lucidworks \
    -DartifactId="$POM_ARTIFACT_ID" \
    -Dversion="$POM_VERSION" \
    -Dpackaging="war" \
    -DgeneratePom=false \
    -Dpomfile=pom.xml \
    -DgeneratePom.description="Lucidworks App Studio"]
