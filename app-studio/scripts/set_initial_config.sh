#!/bin/bash
# script.sh

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" || exit ; pwd -P )
cd "$parent_path/" || exit


cd "../src/main/resources/conf/services/api/" || exit

#
# Getting Fusion connection details
#

  echo "What is your Fusion host? (e.g. localhost, 111.222.333.444 or fusion.example.com -- do not include protocol or port) "
  read -r HOST

    if [[ -n "$HOST" ]]
    then
      # Update the configuration file
      sed -i '' -e "s/^host: .*/host: $HOST/" fusion.conf
    fi

  echo "If you know your Fusion port, enter it here: (typically 6764 for Fusion 5, or 8764 for Fusion 4 and earlier) "
  read -r PORT

    if [[ -n "$PORT" ]]
    then
      sed -i '' -e "s/^port: .*/port: $PORT/" fusion.conf
    fi

  echo "If you know your Fusion protocol (http or https), enter it here: "
  read -r PROTOCOL

    if [[ -n "$PROTOCOL" ]]
    then
      sed -i '' -e "s/^protocol: .*/protocol: $PROTOCOL/" fusion.conf
    fi

  echo "Please enter your Fusion username here: "
  read -r USERNAME

  echo "Please enter your Fusion password here: "
  read -r PASSWORD


#
# Getting App Names from Fusion
#

cd "../../platforms/fusion" || exit

# If we were able to retrieve all of the above..
if [ ! -z "$HOST" -a ! -z "$PORT" -a ! -z "$PROTOCOL" -a ! -z "$USERNAME" -a ! -z "$PASSWORD" ]
      then
        appnames=$(curl --connect-timeout 5 -u $USERNAME:$PASSWORD $HOST:$PORT/api/apps | grep -o -E '"name" : ".*"' | grep -o -E ' ".*"' | grep -o -E '"[^"]+' | grep -o -E '[^"]+')

        #Check if response contains app names
        if [ -z "$appnames" ]
        then
          echo 'Could not establish a connection with Fusion :('
          echo ' '
          echo "What is the name of your Fusion App? "
          read -r appname

        else
          APPNAMEARRAY=()

          for I in {1..100}
          do
            newappname=$(echo "$appnames" | awk -v var=$I '{i++}i==var')

            if [ -z "$newappname" ]
              then
                break
            fi
            APPNAMEARRAY+=("$newappname")
          done
          #  echo "${APPNAMEARRAY[@]}"

          PS3='Please enter the number of your Fusion App: '
          select opt in "${APPNAMEARRAY[@]}"
          do
            appname=$( echo "$opt")
          break
          done
        fi
fi

# Updating social config
#  echo $appname
  if [[ -n "$appname" ]]
  then
    userPrefs=$appname'_user_prefs'
    sed -i '' -e "s/collection: .*/collection: $userPrefs/" social.conf
  fi


#
# Getting Query Profiles from Fusion
#

cd "../../message/service" || exit

#  echo $qpnames
  #Check if response contains query profiles
  if [ ! -z "$appnames" ]
  then
      qpnames=$(curl --connect-timeout 5 -u $USERNAME:$PASSWORD $HOST:$PORT/api/query-profiles | grep -o -E '"id" : ".*"' | grep -o -E ' ".*"' | grep -o -E '"[^"]+' | grep -o -E '[^"]+')
  fi
  if [ -z "$qpnames" ]
    then
      echo 'Could not establish a connection with Fusion :('
      echo ' '
      echo "What is the name of your Fusion query profile? "
      read -r qpname
    else
      APPNAMEARRAY=()

      for I in {1..100}
      do
        newqp=$(echo "$qpnames" | awk -v var=$I '{i++}i==var')

        if [ -z "$newqp" ]
          then
            break
        fi
        QPARRAY+=("$newqp")
      done
      #  echo "${APPNAMEARRAY[@]}"
      #newappnames=$(echo "$appnames"| awk '{ print "\""$0"\""}')

      PS3='Please enter the number of the primary Fusion query profile that you would like to target : '
      select opt in "${QPARRAY[@]}"
        do
#          echo $opt
          qpname=$( echo "$opt")
          break
        done
  fi

# Updating signals and platform config

  if [[ -n "$qpname" ]]
  then
    sed -i '' -e "s/query-profile: .*/query-profile: $qpname/" fusion.conf
  fi

cd "../../platforms/fusion" || exit

  if [[ -n "$qpname" ]]
  then
     sed -i '' -e "s/query-profile: .*/query-profile: $qpname/" data.conf
  fi

cd "$parent_path/" || exit
cd "../src/main/webapp/views/" || exit

#Update the search.html view

  echo "Enter the names of any facets you'd like to display (in the format: facet1,facet2,facet3)"
  read -r FACETS
    if [[ -n "$FACETS" ]]
    then
      sed -i '' -e "s/\(<search:query.*var=\"query\".*facets=\"\).*\(\".*><\/search:query>\)/\1$FACETS\2/" search.html
    fi

  echo "Enter the name of your title field: "
  read -r TITLE

    if [[ -n "$TITLE" ]]
    then
      sed -i '' -e "s/\(<search:field.*name=\"\).*\(\".*styling=\"title\".*\)/\1$TITLE\2/" search.html
#      sed -i '' -e "s/name=\"title_s\"/name=\"$TITLE\"/" search.html
      sed -i '' -e "s/\(title=.*field:\'\).*\(\'.*\)/\1$TITLE\2/" search.html
    fi

  echo "Enter the name of your URL field: "
  read -r URL

    if [[ -n "$URL" ]]
    then
      sed -i '' -e "s/\(<search:field.*styling=\"title\".*urlfield=\"\).*\(\".*\)/\1$URL\2/" search.html
    fi

  echo "Enter the name of your description or body field: "
  read -r BODY
    if [[ -n "$BODY" ]]
    then
      sed -i '' -e "s/\(<search:field.*name=\"\).*\(\".*styling=\"description\".*\)/\1$BODY\2/" search.html
    fi

  echo "Enter the name of your date field: "
  read -r DATE
    if [[ -n "$DATE" ]]
    then
      sed -i '' -e "s/\(<search:field.*name=\"\).*\(\".*label=\"Date Indexed\".*\)/\1$DATE\2/" search.html
    fi

echo "Great! We've updated your project to use these settings. Now run the command './app-studio start -f' to run the app on your local machine. For further reference, please go to https://doc.lucidworks.com/app-studio/latest/index.html"