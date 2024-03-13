// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {ERC721Token} from "../src/tokens/ERC721Token.sol";
import {ERC1155Token} from "../src/tokens/ERC1155Token.sol";
import {IToken} from "./tokens/IToken.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TokenFactory is Ownable {
    UpgradeableBeacon public _beaconERC721;
    UpgradeableBeacon public _beaconERC1155;

    mapping(address => address[]) ownerToTokens;

    event TokenCreated(address token, bool isERC721);

    constructor() Ownable(msg.sender) {
        ERC721Token tokenERC721 = new ERC721Token();
        ERC1155Token tokenERC1155 = new ERC1155Token();
        tokenERC721.setInitialized();
        tokenERC1155.setInitialized();
        _beaconERC721 = new UpgradeableBeacon(
            address(tokenERC721),
            address(this)
        );
        _beaconERC1155 = new UpgradeableBeacon(
            address(tokenERC1155),
            address(this)
        );
    }

    function createToken(
        bool isERC721,
        string memory name_,
        string memory symbol_,
        string memory baseTokenURI_,
        bool hasRoyalty_
    ) external returns (address tokenAddress) {
        bytes memory beaconData = abi.encodeWithSelector(
            IToken.initialize.selector,
            name_,
            symbol_,
            baseTokenURI_,
            msg.sender,
            hasRoyalty_
        );

        if (isERC721) {
            tokenAddress = address(
                new BeaconProxy(address(_beaconERC721), beaconData)
            );
            emit TokenCreated(tokenAddress, true);
        } else {
            tokenAddress = address(
                new BeaconProxy(address(_beaconERC1155), beaconData)
            );
            emit TokenCreated(tokenAddress, false);
        }

        ownerToTokens[msg.sender].push(tokenAddress);
    }

    function getTokens() external view returns (address[] memory) {
        return ownerToTokens[msg.sender];
    }

    function getTokens(address owner) external view returns (address[] memory) {
        return ownerToTokens[owner];
    }

    function upgradeBeaconERC721(address newImplementation) external onlyOwner {
        _beaconERC721.upgradeTo(newImplementation);
    }

    function upgradeBeaconERC1155(
        address newImplementation
    ) external onlyOwner {
        _beaconERC1155.upgradeTo(newImplementation);
    }
}
