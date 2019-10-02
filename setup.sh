#!/bin/bash

MYSQL_POD=$(kubectl get po --selector=tier=mysql -o jsonpath='{.items[0].metadata.name}')

kubectl exec -ti $MYSQL_POD -- mysql --user=root --password=my-password -e "CREATE USER 'datadog'@'%' IDENTIFIED BY 'mypassword';"
kubectl exec -ti $MYSQL_POD -- mysql --user=root --password=my-password -e "GRANT REPLICATION CLIENT ON *.* TO 'datadog'@'%' WITH MAX_USER_CONNECTIONS 5;"
kubectl exec -ti $MYSQL_POD -- mysql --user=root --password=my-password -e "GRANT PROCESS ON *.* TO 'datadog'@'%';"
kubectl exec -ti $MYSQL_POD -- mysql --user=root --password=my-password -e "GRANT SELECT ON performance_schema.* TO 'datadog'@'%';"
