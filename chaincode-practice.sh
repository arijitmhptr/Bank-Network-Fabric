export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/msp/tlscacerts/tlsca.bank.com-cert.pem
export PEER0_ORG1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

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

setGlobalsForPeer0ICICI(){
    export CORE_PEER_LOCALMSPID="ICICIMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ICICI.bank.com/users/Admin@ICICI.bank.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
}

CHANNEL_NAME="bankchannel"
CC_NAME="loan"

chaincodecreate() {
    echo "============= Chaincode Create ================"
    # setGlobalsForPeer0HDFC
    setGlobalsForPeer0ICICI

        # peer chaincode invoke -o localhost:7050 \
        # --ordererTLSHostnameOverride RBI1.bank.com \
        # --tls $CORE_PEER_TLS_ENABLED \
        # --cafile $ORDERER_CA \
        # -C $CHANNEL_NAME -n ${CC_NAME} \
        # --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        # --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        # -c '{"function": "queryloan","Args":["LOAN4"]}'

        # peer chaincode invoke -o localhost:7050 \
        # --ordererTLSHostnameOverride RBI1.bank.com \
        # --tls $CORE_PEER_TLS_ENABLED \
        # --cafile $ORDERER_CA \
        # -C $CHANNEL_NAME -n ${CC_NAME} \
        # --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        # --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        # -c '{"function": "gethistorydata","Args":["LOAN4"]}'

        # peer chaincode invoke -o localhost:7050 \
        # --ordererTLSHostnameOverride RBI1.bank.com \
        # --tls $CORE_PEER_TLS_ENABLED \
        # --cafile $ORDERER_CA \
        # -C $CHANNEL_NAME -n ${CC_NAME} \
        # --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        # --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        # -c '{"function": "changeName","Args":["LOAN4","Priyata"]}'

        # peer chaincode invoke -o localhost:7050 \
        # --ordererTLSHostnameOverride RBI1.bank.com \
        # --tls $CORE_PEER_TLS_ENABLED \
        # --cafile $ORDERER_CA \
        # -C $CHANNEL_NAME -n ${CC_NAME} \
        # --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        # --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        # -c '{"function": "deleteloan","Args":["LOAN4"]}'

    # export Loan=$(echo -n "{\"key\":\"Loan789\", \"Account\":\"1000\",\"Amount\":\"2500025\",\"Name\":\"HDFC\",\"Mobile\":\"123456\"}" | base64 | tr -d \\n)
    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride RBI1.bank.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME} \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    #     -c '{"function": "createloanImplicitHDFC", "Args":["Loan989", "1000", "44000", "123456", "HDFC"]}' \
        # --transient "{\"loan\":\"$Loan\"}"

         peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride RBI1.bank.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function": "createloanImplicitICICI", "Args":["Loan989", "1000", "44000", "123456", "ICICI"]}' \
       
    }

chaincodequery() {
    echo "============= Chaincode query ================"
    setGlobalsForPeer0HDFC

    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryloan","Args":["LOAN4"]}'
    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryallloan","Args":[]}'

    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "readPrivateloan","Args":["privateloan","Loan555"]}'

    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "readloanImplicitHDFC","Args":["Loan989"]}'

    setGlobalsForPeer0ICICI
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "readloanImplicitICICI","Args":["Loan989"]}'
    
}

# chaincodecreate
chaincodequery