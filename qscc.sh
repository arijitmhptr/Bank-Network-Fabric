export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/bank.com/orderers/RBI1.bank.com/msp/tlscacerts/tlsca.bank.com-cert.pem
export PEER0_ORG1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME=bankchannel

setGlobalsForOrderer() {
    export CORE_PEER_LOCALMSPID="RBIMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp

}

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
echo "=========================Before calling Invoke functions"
invokeFunctions() {
    # Get Transaction By tx id
    # peer chaincode invoke \
    #     -o localhost:7050 \
    #     --cafile $ORDERER_CA \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    #     -C bankchannel -n qscc \
    #     -c '{"function":"GetTransactionByID","Args":["bankchannel", "313e9f73e4ed64b85a0339d19dd918feab13a64548b257e412926621a90f36b5"]}'
    setGlobalsForPeer0HDFC
    # peer chaincode invoke \
    #     -o localhost:7050 \
    #     --ordererTLSHostnameOverride RBI1.bank.com \
    #     --cafile $ORDERER_CA \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    #     -C bankchannel -n qscc \
    #     -c '{"function":"GetChainInfo","Args":["bankchannel"]}'

    peer chaincode invoke \
        -o localhost:7050 \
        --cafile $ORDERER_CA \
        --tls $CORE_PEER_TLS_ENABLED \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        -C bankchannel -n qscc \
        -c '{"function":"GetBlockByNumber","Args":["bankchannel","2"]}'

}

invokeFunctions
