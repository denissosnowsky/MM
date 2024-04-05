-include .env

.PHONY: all test deploy

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo " make deploy [ARGS=...]"

build:; forge build

install:; forge install

test:; forge test

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(SEPOLIA_ETHERSCAN_API_KEY) -vvvv
endif

ifeq ($(findstring --network sepoliaOptimizm,$(ARGS)),--network sepoliaOptimizm)
	NETWORK_ARGS := --rpc-url $(OPTIMIZM_RPC_URL) --private-key $(OPTIMIZM_PRIVATE_KEY) --broadcast -vvvv
endif

ifeq ($(findstring --network optimism,$(ARGS)),--network optimism)
	NETWORK_ARGS := --rpc-url $(OPTIMISM_RPC_URL) --private-key $(OPTIMISM_PRIVATE_KEY) --with-gas-price $(OPTIMISM_GAS_PRICE) --broadcast --verify --etherscan-api-key $(OPTIMISM_ETHERSCAN_API_KEY) -vvvv
endif


deploy:
	@forge script script/DeployFactory.s.sol:DeployFactory $(NETWORK_ARGS)