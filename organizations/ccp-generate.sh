#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=land-registry
ORG_CAMEL=LandRegistry
P0PORT=5051
CAPORT=5054
PEERPEM=organizations/peerOrganizations/land-registry.ousl.com/tlsca/tlsca.land-registry.ousl.com-cert.pem
CAPEM=organizations/peerOrganizations/land-registry.ousl.com/ca/ca.land-registry.ousl.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/land-registry.ousl.com/connection-land-registry.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/land-registry.ousl.com/connection-land-registry.yaml

ORG=registrar-general
ORG_CAMEL=RegistrarGeneral
P0PORT=6051
CAPORT=6054
PEERPEM=organizations/peerOrganizations/registrar-general.ousl.com/tlsca/tlsca.registrar-general.ousl.com-cert.pem
CAPEM=organizations/peerOrganizations/registrar-general.ousl.com/ca/ca.registrar-general.ousl.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/registrar-general.ousl.com/connection-registrar-general.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/registrar-general.ousl.com/connection-registrar-general.yaml


ORG=notary
ORG_CAMEL=Notary
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/notary.ousl.com/tlsca/tlsca.notary.ousl.com-cert.pem
CAPEM=organizations/peerOrganizations/notary.ousl.com/ca/ca.notary.ousl.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/notary.ousl.com/connection-notary.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/notary.ousl.com/connection-notary.yaml


ORG=other
ORG_CAMEL=Other
P0PORT=8051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/other.ousl.com/tlsca/tlsca.other.ousl.com-cert.pem
CAPEM=organizations/peerOrganizations/other.ousl.com/ca/ca.other.ousl.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/other.ousl.com/connection-other.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/other.ousl.com/connection-other.yaml
