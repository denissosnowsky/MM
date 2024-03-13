// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

interface IToken {
    function initialize(
        string memory name_,
        string memory symbol_,
        string memory baseTokenURI_,
        address initialOwner_,
        bool hasRoyalty_
    ) external;
}
