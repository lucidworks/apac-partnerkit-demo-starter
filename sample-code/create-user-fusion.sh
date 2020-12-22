# sample call to list user names in fusion server. 
curl -s -uadmin:password123! http://f5:6764/api/users | jq .[].username
"webapps-system-account"
"admin"
"catalog_jdbc_service_account"

# sample call to create a user in a fusion server via api
echo '{"username":"claire","password":"password123","roleNames":["developer"],"permissions":[],"realmName":"native"}' | curl -s -uadmin:password123! -X POST -H 'Content-Type:application/json' -d @- http://f5:6764/api/users

