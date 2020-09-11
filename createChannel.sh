export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/msp/tlscacerts/tlsca.bank.com-cert.pem
export PEER0_ORG1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME="bankchannel"

# setGlobalsForOrderer(){
#     export CORE_PEER_LOCALMSPID="RBIMSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/msp/tlscacerts/tlsca.bank.com-cert.pem
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp
    
# }

setGlobalsForPeer0HDFC(){
    export CORE_PEER_LOCALMSPID="HDFCMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/HDFC.bank.com/users/Admin@HDFC.bank.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1HDFC(){
    export CORE_PEER_LOCALMSPID="HDFCMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/HDFC.bank.com/users/Admin@HDFC.bank.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
    
}

setGlobalsForPeer0ICICI(){
    export CORE_PEER_LOCALMSPID="ICICIMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ICICI.bank.com/users/Admin@ICICI.bank.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    
}

setGlobalsForPeer1ICICI(){
    export CORE_PEER_LOCALMSPID="ICICIMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ICICI.bank.com/users/Admin@ICICI.bank.com/msp
    export CORE_PEER_ADDRESS=localhost:10051
    
}

createChannel(){
    # rm -rf ./channel-artifacts/*
    setGlobalsForPeer0HDFC
    
    peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride RBI1.bank.com\
    -f ./artifacts/channel/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

removeOldCrypto(){
    rm -rf ./api-1.4/crypto/*
    rm -rf ./api-1.4/fabric-client-kv-org1/*
    rm -rf ./api-2.0/org1-wallet/*
    rm -rf ./api-2.0/org2-wallet/*
}


joinChannel(){
    setGlobalsForPeer0HDFC
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer1HDFC
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer0ICICI
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer1ICICI
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
}

updateAnchorPeers(){
    setGlobalsForPeer0HDFC
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride RBI1.bank.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobalsForPeer0ICICI
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride RBI1.bank.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    echo "------------------------- Channel created, joined and updated -------"
}

# removeOldCrypto

createChannel
joinChannel
updateAnchorPeers