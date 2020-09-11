export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/msp/tlscacerts/tlsca.bank.com-cert.pem
export PEER0_ORG1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export PRIVATE_DATA_CONFIG=${PWD}/artifacts/private-data/collections_config.json

export CHANNEL_NAME=bankchannel

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

presetup() {
    echo "=========================== Vendoring Go dependencies ====================="
    pushd ./artifacts/src/chaincode
    GO111MODULE=on go mod vendor
    popd
    echo "=========================== Finished vendoring Go dependencies ============"
}

CHANNEL_NAME="bankchannel"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
CC_SRC_PATH="./artifacts/src/chaincode"
CC_NAME="loan"

packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    # setGlobalsForPeer0HDFC
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged ===================== "
}
# packageChaincode

installChaincode() {

    setGlobalsForPeer0HDFC
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.HDFC ===================== "

    # setGlobalsForPeer1HDFC
    # peer lifecycle chaincode install ${CC_NAME}.tar.gz
    # echo "===================== Chaincode is installed on peer1.HDFC ===================== "

    setGlobalsForPeer0ICICI
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.ICICI ===================== "

    # setGlobalsForPeer1ICICI
    # peer lifecycle chaincode install ${CC_NAME}.tar.gz
    # echo "===================== Chaincode is installed on peer1.ICICI ===================== "
}

# installChaincode

queryInstalled() {
    setGlobalsForPeer0HDFC
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.HDFC channel ===================== "
}

# queryInstalled

# --collections-config ./artifacts/private-data/collections_config.json \
#         --signature-policy "OR('Org1MSP.member','Org2MSP.member')" \
# --collections-config $PRIVATE_DATA_CONFIG \

approveForHDFC() {
    setGlobalsForPeer0HDFC
    # set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride RBI1.bank.com --tls \
        --collections-config $PRIVATE_DATA_CONFIG \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}
    # set +x

    echo "===================== chaincode approved from HDFC ===================== "

}

# approveForHDFC

# --signature-policy "OR ('Org1MSP.member')"
# --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA
# --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles $PEER0_ORG2_CA
#--channel-config-policy Channel/Application/Admins
# --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer')"

checkCommitReadyness() {
    setGlobalsForPeer0HDFC
    peer lifecycle chaincode checkcommitreadiness \
        --collections-config $PRIVATE_DATA_CONFIG \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from HDFC ===================== "
}

# checkCommitReadyness

# --collections-config ./artifacts/private-data/collections_config.json \
# --signature-policy "OR('Org1MSP.member','Org2MSP.member')" \
approveForICICI() {
    setGlobalsForPeer0ICICI

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride RBI1.bank.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --collections-config $PRIVATE_DATA_CONFIG \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}

    echo "===================== chaincode approved from ICICI ===================== "
}

# approveForICICI

checkCommitReadyness() {

    setGlobalsForPeer0HDFC
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --collections-config $PRIVATE_DATA_CONFIG \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from ICICI ===================== "
}

# checkCommitReadyness

commitChaincodeDefination() {
    setGlobalsForPeer0HDFC
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride RBI1.bank.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --collections-config $PRIVATE_DATA_CONFIG \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required
echo "===================== commitChaincodeDefination ===================== "
}

# commitChaincodeDefination

queryCommitted() {
    setGlobalsForPeer0HDFC
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
    echo "===================== query Committed ===================== "

}

# queryCommitted

chaincodeInvokeInit() {
    setGlobalsForPeer0HDFC
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride RBI1.bank.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --isInit -c '{"Args":[]}'
    echo "===================== chaincodeInvokeInit ===================== "
}
# chaincodeInvokeInit

chaincodeInvoke() {
    setGlobalsForPeer0HDFC

    ## Create Car
    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME}  \
    #     --peerAddresses localhost:7051 \
    #     --tlsRootCertFiles $PEER0_ORG1_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA   \
    #     -c '{"function": "createCar","Args":["Car-ABCDEEE", "Audi", "R8", "Red", "Pavan"]}'

    ## Init ledger
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride RBI1.bank.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function": "initLedger","Args":[]}'

        # peer chaincode invoke -o localhost:7050 \
        # --ordererTLSHostnameOverride RBI1.bank.com \
        # --tls $CORE_PEER_TLS_ENABLED \
        # --cafile $ORDERER_CA \
        # -C $CHANNEL_NAME -n ${CC_NAME} \
        # --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        # --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        # -c '{"Args":[]}'

    ## Add private data
    export Loan=$(echo -n "{\"key\":\"Loan555\", \"Account\":\"9999\",\"Amount\":\"2500000\",\"Name\":\"Prince\",\"MObile\":\"100\"}" | base64 | tr -d \\n)
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride RBI1.bank.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function": "createprivateloan", "Args":[]}' \
        --transient "{\"loan\":\"$Loan\"}"
    echo "===================== chaincodeInvoke ===================== "
}

# chaincodeInvoke

chaincodeQuery() {
    setGlobalsForPeer0ICICI

    # Query all cars
    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["queryAllCars"]}'

    # Query Car by Id
    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryCar","Args":["CAR5"]}'
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryloan","Args":["LOAN1"]}'
    
    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "querlyloanbyName","Args":["Arijit"]}'
    #'{"Args":["GetSampleData","Key1"]}'

    # Query Private Car by Id
    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "readPrivateCar","Args":["1111"]}'
    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "readCarPrivateDetails","Args":["1111"]}'
echo "===================== chaincodeQuery ===================== "
}

# chaincodeQuery

# Run this function if you add any new dependency in chaincode
# presetup
packageChaincode
installChaincode
queryInstalled
approveForHDFC
checkCommitReadyness
approveForICICI
checkCommitReadyness
commitChaincodeDefination
queryCommitted
chaincodeInvokeInit
sleep 5
chaincodeInvoke
sleep 3
chaincodeQuery
