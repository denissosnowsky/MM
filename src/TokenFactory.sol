// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {ERC721Token} from "../src/tokens/ERC721Token.sol";
import {ERC1155Token} from "../src/tokens/ERC1155Token.sol";
import {IToken} from "./tokens/IToken.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TokenFactory {
    using Clones for address;

    ERC721Token private _templateERC721;
    ERC1155Token private _templateERC1155;
    mapping(address => address[]) ownerToTokens;

    event TokenCreated(address token, bool isERC721);

    constructor() {
        _templateERC721 = new ERC721Token();
        _templateERC1155 = new ERC1155Token();
        _templateERC721.setInitialized();
        _templateERC1155.setInitialized();
    }

    function createToken(
        bool isERC721,
        string memory name_,
        string memory symbol_,
        string memory baseTokenURI_,
        bool hasRoyalty_
    ) external returns (address tokenAddress) {
        if (isERC721) {
            tokenAddress = address(_templateERC721).clone();
            emit TokenCreated(tokenAddress, true);
        } else {
            tokenAddress = address(_templateERC1155).clone();
            emit TokenCreated(tokenAddress, false);
        }

        ownerToTokens[msg.sender].push(tokenAddress);

        IToken(tokenAddress).initialize(
            name_,
            symbol_,
            baseTokenURI_,
            msg.sender,
            hasRoyalty_
        );
    }

    function getTokens() external view returns (address[] memory) {
        return ownerToTokens[msg.sender];
    }

    function getTokens(address owner) external view returns (address[] memory) {
        return ownerToTokens[owner];
    }
}
