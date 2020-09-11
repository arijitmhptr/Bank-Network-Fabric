#Run all the containers--command
docker-compose -f ./artifacts/docker-compose.yaml up -d
echo "========== All containers are UP ================="
sleep 20

#Create channel--command
sleep 10
./createChannel.sh
echo "========== Channel created successfully ================="

#Deploy chaincode--command
sleep 10
./deployChaincode.sh
echo "========== Chaincode deployed successfully ================="