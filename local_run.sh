# Run on the native docker host, not inside the container.
echo" get the docker container_id"
docker_id=`docker ps | grep odfe-node1 | cut -d' ' -f1`
echo "docker_id: ${docker_id}"

if [[ x${docker_id}x == "xx" ]]; then
 echo "failed to get docker_id of odfe-node1. Please check that it is running"
 exit 1
fi

echo "copy the keys out of the container"
docker cp ${docker_id}:/usr/share/elasticsearch/config/kirk.pem kirk.pem
docker cp ${docker_id}:/usr/share/elasticsearch/config/kirk-key.pem kirk-key.pem
docker cp ${docker_id}:/usr/share/elasticsearch/config/root-ca.pem root-ca.pem

echo "convert the root-ca.pem to a .crt and discard the .pem"
openssl x509 -outform der -in root-ca.pem -out root-ca.crt
if [ -f "root-ca.crt" ] && [ -s "root-ca.crt" ]
 then
    rm root-ca.pem
 else 
    echo "root-ca.crt file does not exist, or is empty. Please convert .pem to .crt manually "
    exit 1
fi

echo "Extraction of keys complete. Ready to configure BurpsuiteLogger++"

