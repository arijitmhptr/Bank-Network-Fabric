#Run all the containers--command
docker-compose -f ./artifacts/docker-compose.yaml down
echo "========== All containers are DOWN ================="

# delete stopped containers
docker rm -v $(docker ps -a -q -f status=exited)

# Delete all docker volumes
docker volume prune