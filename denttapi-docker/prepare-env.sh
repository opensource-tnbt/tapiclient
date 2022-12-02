#!/bin/bash
FILE=/etc/opnfv_testapi/config.ini


[[ "${mongodb_url}" == "" ]] && mongodb_url=mongodb://mongo:27017/
[[ "${base_url}" == "" ]] && base_url=http://localhost:8000
[[ ! "${auth}" =~ [f|F]alse ]] && auth=true

auth_server=`echo ${auth:0:1} | tr '[:lower:]' '[:upper:]'``echo ${auth:1} | tr '[:upper:]' '[:lower:]'`
auth_web=`echo ${auth} | tr '[:upper:]' '[:lower:]'`
crudini --set --existing ${FILE} mongo url ${mongodb_url}
crudini --set --existing ${FILE} api url ${base_url}/api/v1
crudini --set --existing ${FILE} ui url ${base_url}
crudini --set --existing ${FILE} api authenticate ${auth_server}

cat > /usr/local/share/opnfv_testapi/testapi-ui/config.json << EOF
{
  "testapiApiUrl": "${base_url}/api/v1",
  "authenticate": ${auth_web}
}
EOF
