# chmod -R 0755 ./crypto-config
# # Delete existing artifacts
# rm -rf ./crypto-config
rm bankchannel.tx
rm -rf ../../channel-artifacts/*

#Generate Crypto artifactes for organizations
# cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/

# System channel
export SYS_CHANNEL="system-channel"

# channel name defaults to "mychannel"
export CHANNEL_NAME="bankchannel"

echo $CHANNEL_NAME

# Generate System Genesis block
echo "#######    Generate System Genesis block  ##########"
configtxgen -profile BankOrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block

# # Generate channel configuration block
echo "#######    Generate channel configuration block  ##########"
configtxgen -profile BankChannel -configPath . -outputCreateChannelTx ./bankchannel.tx -channelID $CHANNEL_NAME

echo "#######    Generating anchor peer update for HDFCMSP  ##########"
configtxgen -profile BankChannel -configPath . -outputAnchorPeersUpdate ./HDFCMSPanchors.tx -channelID $CHANNEL_NAME -asOrg HDFC

echo "#######    Generating anchor peer update for ICICIMSP  ##########"
configtxgen -profile BankChannel -configPath . -outputAnchorPeersUpdate ./ICICIMSPanchors.tx -channelID $CHANNEL_NAME -asOrg ICICI