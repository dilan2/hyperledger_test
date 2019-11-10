crypto: ./bin/cryptogen
	bin/cryptogen generate --config=crypto-config.yaml --output "crypto-config"

orderer: ./bin/configtxgen
	bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./config/genesis.block

channel: ./bin/configtxgen
	bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./config/mychannel.tx -channelID mychannel

org1channel: ./bin/cryptogen 
	docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel create -o orderer.example.com:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx
	docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel join -b mychannel.block

org2channel: ./bin/cryptogen
	docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org2.example.com/msp" peer0.org2.example.com  peer channel fetch 0 mychannel.block -o orderer.example.com:7050 -c mychannel
	docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org2.example.com/msp" peer0.org2.example.com peer channel join -b mychannel.block

org2channel1: ./bin/cryptogen
	docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org2.example.com/msp" peer1.org2.example.com  peer channel fetch 0 mychannel.block -o orderer.example.com:7050 -c mychannel
	docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org2.example.com/msp" peer1.org2.example.com peer channel join -b mychannel.block
