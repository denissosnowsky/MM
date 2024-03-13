// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {TokenFactory} from "../src/TokenFactory.sol";
import {ERC1155Token} from "../src/tokens/ERC1155Token.sol";
import {ERC721Token} from "../src/tokens/ERC721Token.sol";

contract DeployFactory is Script {
    function run() external returns (TokenFactory factory) {
        vm.startBroadcast();
        factory = new TokenFactory();
        vm.stopBroadcast();
    }
}
