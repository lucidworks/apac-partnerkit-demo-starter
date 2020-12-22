#!/bin/bash
# ----------------------------------------------------------------------------
# Partner Demo Kit configuration preparation script
# ----------------------------------------------------------------------------
# The purpose of this script is to automate the modification of App Studio
# configuration files and Fusion App configuration files
#
# This script expects the app-studio folder to be present in the same directory
# this script is run from. 
# 
# INSTRUCTIONS
# 1. Install Fusion 5.3 and create a fusion app (refer to repository README for instructions)
# 2. Run this script with the following parameters:
#    -h : the fusion hostname (e.g. localhost)
#    -p : the fusion port (e.g. 6764)
#    -s : the protocol of your Fusion server (http or https)
#    -a : the fusion app name
#    -t : the title to use on the search and pages
# 
# Sample command
# ./setup.sh -h 'localhost' -p 8764 -s 'http' -a 'ATC' -t 'Air Traffic Control'
# 
# IMPORTANT
# the -a parameter must be escaped (e.g. My Favorite App needs to be passed
# as My-Favorite-App)
#
# NOTE
# npm is required to run App Studio; to install:
# curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
# sudo yum install nodejs
# ----------------------------------------------------------------------------

timestamp=`date "+%Y-%m-%d %H:%M:%S"`

# The absolute path to this script
base_dir=$PWD

log_file=${base_dir}/setup.log

echo "[${timestamp}] Script has started" >> ${log_file}

echo "[${timestamp}] The base directory is ${base_dir}" >> ${log_file}

while getopts ":h:p:s:a:t:" opt; do
  case $opt in
    h) param_fusion_hostname="$OPTARG"
    ;;
    p) param_fusion_port="$OPTARG"
    ;;
    s) param_fusion_protocol="$OPTARG"
    ;;
    a) param_app_name="$OPTARG"
    ;;
    t) param_app_title="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ -z "$param_fusion_hostname" || -z "$param_fusion_port" || -z "$param_fusion_protocol" || -z "$param_app_name" || -z "$param_app_title" ]]; then
  echo 'One or more variables are undefined'
  echo "[${timestamp}] One or more variables are undefined; exiting" >> ${log_file}
  exit 1
fi

# If the app name contains space(s), replace space(s) with underscore
echo $param_app_name

param_app_name_without_space="${param_app_name// /_}"
echo $param_app_name_without_space

# The app studio directory
app_studio_dir=app-studio

# The fusion config directory
fusion_app=${base_dir}/fusion-app/partnerkit
fusion_object_file=${base_dir}/fusion-app/partnerkit/objects.json

# Check to make sure the directory exists
if [ -d "$app_studio_dir" ]; then
  echo "[${timestamp}] app-studio directory found, proceeding" >> ${log_file}
else
  echo "[${timestamp}] It doesn't appear that working directory exists; exiting" >> ${log_file}
  exit 0
fi

# ===================================================
# Modify App Studio configuration files
# ===================================================
# Edit `services/api/fusion.conf` which controls the Fusion server to use
path_services_api_fusion=${base_dir}/${app_studio_dir}/src/main/resources/conf/services/api/fusion.conf
echo "[${timestamp}] Modifying Fusion server hostname to ${param_fusion_hostname} in file ${path_services_api_fusion}" >> ${log_file}
sed -i -e "s/FUSION_HOST/${param_fusion_hostname}/g" ${path_services_api_fusion}

# Edit `services/api/fusion.conf` which controls the Fusion server port to use
echo "[${timestamp}] Modifying Fusion server port to ${param_fusion_port} in file ${path_services_api_fusion}" >> ${log_file}
sed -i -e "s/FUSION_PORT/${param_fusion_port}/g" ${path_services_api_fusion}

# Edit `services/api/fusion.conf` which controls the Fusion server protocol to use
echo "[${timestamp}] Modifying Fusion protocol to ${param_fusion_protocol} in file ${path_services_api_fusion}" >> ${log_file}
sed -i -e "s/FUSION_PROTOCOL/${param_fusion_protocol}/g" ${path_services_api_fusion}

# Edit the `resources/conf/twigkit.conf` which configures the name of the app-id for signal capture
path_resources_conf_twigkit=${base_dir}/${app_studio_dir}/src/main/resources/conf/twigkit.conf
echo "[${timestamp}] Modifying app name (${param_app_name}) in file ${path_resources_conf_twigkit}" >> ${log_file}
sed -i -e "s/app-studio-enterprise/${param_app_name}/g" ${path_resources_conf_twigkit}

# Edit `platforms/fusion/social.conf` which onfigures the Lucidworks Appkit Social Module
path_platforms_fusion_social=${base_dir}/${app_studio_dir}/src/main/resources/conf/platforms/fusion/social.conf
echo "[${timestamp}] Modifying app name (${param_app_name}) in file ${path_platforms_fusion_social}" >> ${log_file}
sed -i -e "s/partnerkit/${param_app_name}/g" ${path_platforms_fusion_social}

# Edit `message/service/fusion.conf` which configures how Signals are sent to Fusion
path_message_service_fusion=${base_dir}/${app_studio_dir}/src/main/resources/conf/message/service/fusion.conf
echo "[${timestamp}] Modifying query profile prefix from 'partnerkit' to (${param_app_name}) in file ${path_message_service_fusion}" >> ${log_file}
sed -i -e "s/partnerkit/${param_app_name}/g" ${path_message_service_fusion}

# Main Document Search
# Edit `platforms/fusion/data/documents/search.conf` which configures the Fusion query profile for main search results
path_platforms_fusion_data=${base_dir}/${app_studio_dir}/src/main/resources/conf/platforms/fusion/data/documents/search.conf
echo "[${timestamp}] Modifying query profile prefix from 'partnerkit' to (${param_app_name}) in file ${path_platforms_fusion_data}" >> ${log_file}
sed -i -e "s/partnerkit/${param_app_name}/g" ${path_platforms_fusion_data}

# Recommendations
# Edit `platforms/fusion/recommendations/` which configures the Fusion query profile for recommendations
items_for_item_content=${base_dir}/${app_studio_dir}/src/main/resources/conf/platforms/fusion/recommendations/items_for_item_content.conf
echo "[${timestamp}] Modifying query profile prefix from 'partnerkit' to (${param_app_name}) in file ${items_for_item_content}" >> ${log_file}
sed -i -e "s/partnerkit/${param_app_name}/g" ${items_for_item_content}

# Edit `platforms/fusion/recommendations/` which configures the Fusion query profile for recommendations
items_for_item=${base_dir}/${app_studio_dir}/src/main/resources/conf/platforms/fusion/recommendations/items_for_item.conf
echo "[${timestamp}] Modifying query profile prefix from 'partnerkit' to (${param_app_name}) in file ${items_for_item}" >> ${log_file}
sed -i -e "s/partnerkit/${param_app_name}/g" ${items_for_item}

# Edit `platforms/fusion/recommendations/` which configures the Fusion query profile for recommendations
items_for_user=${base_dir}/${app_studio_dir}/src/main/resources/conf/platforms/fusion/recommendations/items_for_user.conf
echo "[${timestamp}] Modifying query profile prefix from 'partnerkit' to (${param_app_name}) in file ${items_for_user}" >> ${log_file}
sed -i -e "s/partnerkit/${param_app_name}/g" ${items_for_user}

# Edit `platforms/fusion/recommendations/` which configures the Fusion query profile for recommendations
queries_for_query=${base_dir}/${app_studio_dir}/src/main/resources/conf/platforms/fusion/recommendations/queries_for_query.conf
echo "[${timestamp}] Modifying query profile prefix from 'partnerkit' to (${param_app_name}) in file ${queries_for_query}" >> ${log_file}
sed -i -e "s/partnerkit/${param_app_name}/g" ${queries_for_query}

# Signals
# Edit `platforms/fusion/signals/` which configures the Fusion query profile for signal driven results
recent_user_clicks=${base_dir}/${app_studio_dir}/src/main/resources/conf/platforms/fusion/signals/recent_user_clicks.conf
echo "[${timestamp}] Modifying query profile prefix from 'partnerkit' to (${param_app_name}) in file ${recent_user_clicks}" >> ${log_file}
sed -i -e "s/partnerkit/${param_app_name}/g" ${recent_user_clicks}

# Edit `platforms/fusion/signals/` which configures the Fusion query profile for signal driven results
recent_user_searches=${base_dir}/${app_studio_dir}/src/main/resources/conf/platforms/fusion/signals/recent_user_searches.conf
echo "[${timestamp}] Modifying query profile prefix from 'partnerkit' to (${param_app_name}) in file ${recent_user_searches}" >> ${log_file}
sed -i -e "s/partnerkit/${param_app_name}/g" ${recent_user_searches}

# Edit `platforms/fusion/signals/` which configures the Fusion query profile for signal driven results
top_global_clicks=${base_dir}/${app_studio_dir}/src/main/resources/conf/platforms/fusion/signals/top_global_clicks.conf
echo "[${timestamp}] Modifying query profile prefix from 'partnerkit' to (${param_app_name}) in file ${top_global_clicks}" >> ${log_file}
sed -i -e "s/partnerkit/${param_app_name}/g" ${top_global_clicks}

# Edit `platforms/fusion/signals/` which configures the Fusion query profile for signal driven results
top_searches_tagcloud=${base_dir}/${app_studio_dir}/src/main/resources/conf/platforms/fusion/signals/top_searches_tagcloud.conf
echo "[${timestamp}] Modifying query profile prefix from 'partnerkit' to (${param_app_name}) in file ${top_searches_tagcloud}" >> ${log_file}
sed -i -e "s/partnerkit/${param_app_name}/g" ${top_searches_tagcloud}

# Edit `platforms/fusion/signals/` which configures the Fusion query profile for signal driven results
top_user_searches=${base_dir}/${app_studio_dir}/src/main/resources/conf/platforms/fusion/signals/top_user_searches.conf
echo "[${timestamp}] Modifying query profile prefix from 'partnerkit' to (${param_app_name}) in file ${top_user_searches}" >> ${log_file}
sed -i -e "s/partnerkit/${param_app_name}/g" ${top_user_searches}

# Typeahead
# Edit `platforms/fusion/typeahead.conf` which configures the Fusion query profile for typeahead
path_typeahead=${base_dir}/${app_studio_dir}/src/main/resources/conf/platforms/fusion/typeahead.conf
echo "[${timestamp}] Modifying query profile prefix from 'partnerkit' to (${param_app_name}) in file ${path_typeahead}" >> ${log_file}
sed -i -e "s/partnerkit/${param_app_name}/g" ${path_typeahead}

# ===================================================
# Modify App Studio HTML pages
# ===================================================
# Modify the summary.html title
path_views_summary=${base_dir}/${app_studio_dir}/src/main/webapp/views/summary.html
echo "[${timestamp}] Modifying page title (${param_app_title}) in file ${path_views_summary}" >> ${log_file}
sed -i -e "s/Enterprise Search/${param_app_title}/g" ${path_views_summary}

# Modify the search.html title
path_views_search=${base_dir}/${app_studio_dir}/src/main/webapp/views/search.html
echo "[${timestamp}] Modifying page title (${param_app_title}) in file ${path_views_search}" >> ${log_file}
sed -i -e "s/Enterprise Search/${param_app_title}/g" ${path_views_search}

# Modify the search-detail.html title
path_views_search_detail=${base_dir}/${app_studio_dir}/src/main/webapp/views/search-detail.html
echo "[${timestamp}] Modifying page title (${param_app_title}) in file ${path_views_search_detail}" >> ${log_file}
sed -i -e "s/Enterprise Search/${param_app_title}/g" ${path_views_search_detail}

# Modify the login form title
path_webapp_login=${base_dir}/${app_studio_dir}/src/main/webapp/login.jsp
echo "[${timestamp}] Modifying login form title (${param_app_title}) in file ${path_webapp_login}" >> ${log_file}
sed -i -e "s/App Studio Enterprise/${param_app_title}/g" ${path_webapp_login}

# App Studio configuration changes done
echo "[${timestamp}] App Studio configuration changes done." >> ${log_file}

# ==============================================================
# Rename all files and folders by replacing all instances 
# of 'partnerkit' to the user defined fusion app name
# ==============================================================
# CD to fusion app folder
cd ${fusion_app}
# Rename directories
find . -depth -type d -name "*partnerkit*" -exec bash -c 'mv -v $1 ${1//partnerkit/'${param_app_name}'}' _ {} \;
# Pause for a second
sleep 1s
# Rename files first
find . -depth -type f -name "*partnerkit*" -exec bash -c 'mv -v $1 ${1//partnerkit/'${param_app_name}'}' _ {} \;

# ==============================================================
# Replace all instances of 'partnerkit' in the file content
# ==============================================================
sed -i '' 's/partnerkit/'${param_app_name}'/g' $fusion_object_file

# ==============================================================
# END
# ==============================================================
cd ${base_dir}
echo "[${timestamp}] Script has completed" >> ${log_file}