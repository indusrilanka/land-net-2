#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/ousl.com/tlsca/tlsca.ousl.com-cert.pem
export PEER0_LAND_REGISTRY_CA=${PWD}/organizations/peerOrganizations/land-registry.ousl.com/tlsca/tlsca.land-registry.ousl.com-cert.pem
export PEER0_REGISTRAR_GENERAL_CA=${PWD}/organizations/peerOrganizations/registrar-general.ousl.com/tlsca/tlsca.registrar-general.ousl.com-cert.pem
export PEER0_NOTARY_CA=${PWD}/organizations/peerOrganizations/notary.ousl.com/tlsca/tlsca.notary.ousl.com-cert.pem
export PEER0_OTHER_CA=${PWD}/organizations/peerOrganizations/other.ousl.com/tlsca/tlsca.other.ousl.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/ousl.com/orderers/orderer.ousl.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/ousl.com/orderers/orderer.ousl.com/tls/server.key

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1    
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="LandRegistryMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_LAND_REGISTRY_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/land-registry.ousl.com/users/Admin@land-registry.ousl.com/msp
    export CORE_PEER_ADDRESS=localhost:5051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="RegistrarGeneralMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_REGISTRAR_GENERAL_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/registrar-general.ousl.com/users/Admin@registrar-general.ousl.com/msp
    export CORE_PEER_ADDRESS=localhost:6051

  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="NotaryMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_NOTARY_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/notary.ousl.com/users/Admin@notary.ousl.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_LOCALMSPID="OtherMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_OTHER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/other.ousl.com/users/Admin@other.ousl.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.land-registry.ousl.com:5051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_ADDRESS=peer0.registrar-general.ousl.com:6051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_ADDRESS=peer0.notary.ousl.com:7051
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_ADDRESS=peer0.other.ousl.com:8051
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.org$1"
    ## Set peer addresses
    if [ -z "$PEERS" ]
    then
	PEERS="$PEER"
    else
	PEERS="$PEERS $PEER"
    fi
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
    ## Set path to TLS certificate
    CA=PEER0_ORG$1_CA
    TLSINFO=(--tlsRootCertFiles "${!CA}")
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
    # shift by one to get to the next organization
    shift
  done
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
