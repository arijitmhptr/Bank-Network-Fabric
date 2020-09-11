createcertificatesForHDFC() {

  echo "Enroll the CA admin"

  mkdir -p crypto-config/peerOrganizations/HDFC.bank.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname HDFC-CA --tls.certfiles ${PWD}/ROOT-CA/HDFC-CA/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-HDFC-CA.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-HDFC-CA.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-HDFC-CA.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-HDFC-CA.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/msp/config.yaml

  echo "Register peer0"
  fabric-ca-client register --caname HDFC-CA --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/ROOT-CA/HDFC-CA/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname HDFC-CA --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/ROOT-CA/HDFC-CA/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname HDFC-CA --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/ROOT-CA/HDFC-CA/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname HDFC-CA --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/ROOT-CA/HDFC-CA/tls-cert.pem

  mkdir -p crypto-config/peerOrganizations/HDFC.bank.com/peers

  #  Peer 0
  mkdir -p crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname HDFC-CA -M ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/msp --csr.hosts peer0.HDFC.bank.com --tls.certfiles ${PWD}/ROOT-CA/HDFC-CA/tls-cert.pem

  cp ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname HDFC-CA -M ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/tls --enrollment.profile tls --csr.hosts peer0.HDFC.bank.com --csr.hosts localhost --tls.certfiles ${PWD}/ROOT-CA/HDFC-CA/tls-cert.pem

  cp ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/tls/ca.crt
  cp ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/tls/server.crt
  cp ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/tls/server.key

  mkdir ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/msp/tlscacerts
  cp ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/tlsca
  cp ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/tlsca/tlsca.HDFC.bank.com-cert.pem

  mkdir ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/ca
  cp ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer0.HDFC.bank.com/msp/cacerts/* ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/ca/ca.HDFC.bank.com-cert.pem

  # Peer1

  mkdir -p crypto-config/peerOrganizations/HDFC.bank.com/peers/peer1.HDFC.bank.com

  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname HDFC-CA -M ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer1.HDFC.bank.com/msp --csr.hosts peer1.HDFC.bank.com --tls.certfiles ${PWD}/ROOT-CA/HDFC-CA/tls-cert.pem

  cp ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer1.HDFC.bank.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname HDFC-CA -M ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer1.HDFC.bank.com/tls --enrollment.profile tls --csr.hosts peer1.HDFC.bank.com --csr.hosts localhost --tls.certfiles ${PWD}/ROOT-CA/HDFC-CA/tls-cert.pem

  cp ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer1.HDFC.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer1.HDFC.bank.com/tls/ca.crt
  cp ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer1.HDFC.bank.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer1.HDFC.bank.com/tls/server.crt
  cp ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer1.HDFC.bank.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/peers/peer1.HDFC.bank.com/tls/server.key


  mkdir -p crypto-config/peerOrganizations/HDFC.bank.com/users
  mkdir -p crypto-config/peerOrganizations/HDFC.bank.com/users/User1@HDFC.bank.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname HDFC-CA -M ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/users/User1@HDFC.bank.com/msp --tls.certfiles ${PWD}/ROOT-CA/HDFC-CA/tls-cert.pem

  mkdir -p crypto-config/peerOrganizations/HDFC.bank.com/users/Admin@HDFC.bank.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname HDFC-CA -M ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/users/Admin@HDFC.bank.com/msp --tls.certfiles ${PWD}/ROOT-CA/HDFC-CA/tls-cert.pem

  cp ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/HDFC.bank.com/users/Admin@HDFC.bank.com/msp/config.yaml

}


createCertificateForICICI() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /crypto-config/peerOrganizations/ICICI.bank.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}//crypto-config/peerOrganizations/ICICI.bank.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ICICI-CA --tls.certfiles ${PWD}/ROOT-CA/ICICI-CA/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ICICI-CA.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ICICI-CA.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ICICI-CA.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ICICI-CA.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ICICI-CA --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/ROOT-CA/ICICI-CA/tls-cert.pem
   

  echo
  echo "Register peer1"
  echo
   
  fabric-ca-client register --caname ICICI-CA --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/ROOT-CA/ICICI-CA/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ICICI-CA --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/ROOT-CA/ICICI-CA/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ICICI-CA --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/ROOT-CA/ICICI-CA/tls-cert.pem
   

  mkdir -p crypto-config/peerOrganizations/ICICI.bank.com/peers
  mkdir -p crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ICICI-CA -M ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/msp --csr.hosts peer0.ICICI.bank.com --tls.certfiles ${PWD}/ROOT-CA/ICICI-CA/tls-cert.pem
   

  cp ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ICICI-CA -M ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/tls --enrollment.profile tls --csr.hosts peer0.ICICI.bank.com --csr.hosts localhost --tls.certfiles ${PWD}/ROOT-CA/ICICI-CA/tls-cert.pem
   

  cp ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/tls/ca.crt
  cp ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/tls/server.crt
  cp ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/tls/server.key

  mkdir ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/msp/tlscacerts
  cp ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/tlsca
  cp ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/tlsca/tlsca.ICICI.bank.com-cert.pem

  mkdir ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/ca
  cp ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer0.ICICI.bank.com/msp/cacerts/* ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/ca/ca.ICICI.bank.com-cert.pem

  # --------------------------------------------------------------------------------
  #  Peer 1
  echo
  echo "## Generate the peer1 msp"
  echo
   
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ICICI-CA -M ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer1.ICICI.bank.com/msp --csr.hosts peer1.ICICI.bank.com --tls.certfiles ${PWD}/ROOT-CA/ICICI-CA/tls-cert.pem
   

  cp ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer1.ICICI.bank.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ICICI-CA -M ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer1.ICICI.bank.com/tls --enrollment.profile tls --csr.hosts peer1.ICICI.bank.com --csr.hosts localhost --tls.certfiles ${PWD}/ROOT-CA/ICICI-CA/tls-cert.pem
   

  cp ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer1.ICICI.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer1.ICICI.bank.com/tls/ca.crt
  cp ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer1.ICICI.bank.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer1.ICICI.bank.com/tls/server.crt
  cp ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer1.ICICI.bank.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/peers/peer1.ICICI.bank.com/tls/server.key
  # -----------------------------------------------------------------------------------

  mkdir -p crypto-config/peerOrganizations/ICICI.bank.com/users
  mkdir -p crypto-config/peerOrganizations/ICICI.bank.com/users/User1@ICICI.bank.com

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ICICI-CA -M ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/users/User1@ICICI.bank.com/msp --tls.certfiles ${PWD}/ROOT-CA/ICICI-CA/tls-cert.pem
   

  mkdir -p crypto-config/peerOrganizations/ICICI.bank.com/users/Admin@ICICI.bank.com

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ICICI-CA -M ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/users/Admin@ICICI.bank.com/msp --tls.certfiles ${PWD}/ROOT-CA/ICICI-CA/tls-cert.pem
   

  cp ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/ICICI.bank.com/users/Admin@ICICI.bank.com/msp/config.yaml

}


createCretificateForRBI() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p crypto-config/ordererOrganizations/RBI.bank.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/ordererOrganizations/RBI.bank.com

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname RBI-CA --tls.certfiles ${PWD}/ROOT-CA/RBI-CA/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-RBI-CA.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-RBI-CA.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-RBI-CA.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-RBI-CA.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/msp/config.yaml

  echo
  echo "Register orderer"
  echo
   
  fabric-ca-client register --caname RBI-CA --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/ROOT-CA/RBI-CA/tls-cert.pem
   

  echo
  echo "Register orderer2"
  echo
   
  fabric-ca-client register --caname RBI-CA --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/ROOT-CA/RBI-CA/tls-cert.pem
   

  echo
  echo "Register orderer3"
  echo
   
  fabric-ca-client register --caname RBI-CA --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/ROOT-CA/RBI-CA/tls-cert.pem
   

  echo
  echo "Register the orderer admin"
  echo
   
  fabric-ca-client register --caname RBI-CA --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/ROOT-CA/RBI-CA/tls-cert.pem
   

  mkdir -p crypto-config/ordererOrganizations/RBI.bank.com/orderers

  #  Orderer1

  mkdir -p crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname RBI-CA -M ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/msp --csr.hosts RBI1.bank.com --csr.hosts localhost --tls.certfiles ${PWD}/ROOT-CA/RBI-CA/tls-cert.pem
   

  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/msp/config.yaml ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname RBI-CA -M ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/tls --enrollment.profile tls --csr.hosts RBI1.bank.com --csr.hosts localhost --tls.certfiles ${PWD}/ROOT-CA/RBI-CA/tls-cert.pem
   

  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/tls/ca.crt
  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/tls/signcerts/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/tls/server.crt
  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/tls/keystore/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/tls/server.key

  mkdir ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/msp/tlscacerts
  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/msp/tlscacerts/tlsca.RBI.bank.com-cert.pem

  mkdir ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/msp/tlscacerts
  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI1.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/msp/tlscacerts/tlsca.RBI.bank.com-cert.pem

  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI2.bank.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname RBI-CA -M ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI2.bank.com/msp --csr.hosts RBI2.bank.com --csr.hosts localhost --tls.certfiles ${PWD}/ROOT-CA/RBI-CA/tls-cert.pem
   

  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/msp/config.yaml ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI2.bank.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname RBI-CA -M ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI2.bank.com/tls --enrollment.profile tls --csr.hosts RBI2.bank.com --csr.hosts localhost --tls.certfiles ${PWD}/ROOT-CA/RBI-CA/tls-cert.pem
   

  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI2.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI2.bank.com/tls/ca.crt
  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI2.bank.com/tls/signcerts/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI2.bank.com/tls/server.crt
  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI2.bank.com/tls/keystore/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI2.bank.com/tls/server.key

  mkdir ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI2.bank.com/msp/tlscacerts
  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI2.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI2.bank.com/msp/tlscacerts/tlsca.RBI.bank.com-cert.pem

  # mkdir ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/msp/tlscacerts
  # cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI2.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/msp/tlscacerts/tlsca.RBI.bank.com-cert.pem

  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI3.bank.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname RBI-CA -M ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI3.bank.com/msp --csr.hosts RBI3.bank.com --csr.hosts localhost --tls.certfiles ${PWD}/ROOT-CA/RBI-CA/tls-cert.pem
   

  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/msp/config.yaml ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI3.bank.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname RBI-CA -M ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI3.bank.com/tls --enrollment.profile tls --csr.hosts RBI3.bank.com --csr.hosts localhost --tls.certfiles ${PWD}/ROOT-CA/RBI-CA/tls-cert.pem
   

  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI3.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI3.bank.com/tls/ca.crt
  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI3.bank.com/tls/signcerts/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI3.bank.com/tls/server.crt
  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI3.bank.com/tls/keystore/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI3.bank.com/tls/server.key

  mkdir ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI3.bank.com/msp/tlscacerts
  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI3.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI3.bank.com/msp/tlscacerts/tlsca.RBI.bank.com-cert.pem

  # mkdir ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/msp/tlscacerts
  # cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/orderers/RBI3.bank.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/msp/tlscacerts/tlsca.RBI.bank.com-cert.pem

  # ---------------------------------------------------------------------------

  mkdir -p crypto-config/ordererOrganizations/RBI.bank.com/users
  mkdir -p crypto-config/ordererOrganizations/RBI.bank.com/users/Admin@RBI.bank.com

  echo
  echo "## Generate the admin msp"
  echo
   
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname RBI-CA -M ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/users/Admin@RBI.bank.com/msp --tls.certfiles ${PWD}/ROOT-CA/RBI-CA/tls-cert.pem
   

  cp ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/msp/config.yaml ${PWD}/crypto-config/ordererOrganizations/RBI.bank.com/users/Admin@RBI.bank.com/msp/config.yaml

}

# sudo rm -rf crypto-config/*
# sudo rm -rf fabric-ca/*

# createcertificatesForHDFC
# createCertificateForICICI
createCretificateForRBI

