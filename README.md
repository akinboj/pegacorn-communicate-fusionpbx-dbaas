# postgresql-labs

\helm upgrade pegacorn-fusionpbx-dbaas-site-a --install --namespace site-a --set serviceName=pegacorn-fusionpbx-dbaas,nodeAffinityLabel=fhirplace,hostPath=/data/fusionpbx-dbaas-site-a/data,hostPathCerts=/data/certificates,basePort=30510,imageTag=1.0.0-snapshot,dbUser=fusionpbx,dbName=fusionpbx,serviceType=NodePort,numOfPods=1 helm-postgres
