// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {ERC1155Supply} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Royalty} from "../extensions/Royalty.sol";
import {IToken} from "./IToken.sol";

contract ERC1155Token is Ownable, ERC1155Supply, Royalty, IToken {
    error ERC1155Token__TokenDoesNotExist();
    error ERC1155Token__RoyaltyIsOff();
    error ERC1155Token__CommonRoyaltyIsOn();
    error ERC1155Token__CommonRoyaltyIsOff();
    error ERC1155Token__AlreadyInitialized();

    using Strings for uint256;

    bool private _initialized;
    uint256 private _tokenCounter;
    // flag to swtich on/off royalties
    bool private _hasRoyalty;
    /**
     * flag to show one general royalty for all tokens
     * or individual royalties for each token
     */
    bool private _isCommonRoyalty;
    string private _name;
    string private _symbol;

    constructor() Ownable(msg.sender) ERC1155("") {
        if (_initialized) {
            revert ERC1155Token__AlreadyInitialized();
        }
    }

    function initialize(
        string memory name_,
        string memory symbol_,
        string memory baseTokenURI_,
        address initialOwner_,
        bool hasRoyalty_
    ) external {
        if (_initialized) {
            revert ERC1155Token__AlreadyInitialized();
        }

        setInitialized();
        _name = name_;
        _symbol = symbol_;
        _hasRoyalty = hasRoyalty_;
        _isCommonRoyalty = true;
        _setURI(baseTokenURI_);
        _transferOwnership(initialOwner_);
    }

    function setInitialized() public {
        _initialized = true;
    }

    function mint(
        address to,
        uint256 value,
        bytes memory data
    ) public onlyOwner {
        _mint(to, _tokenCounter, value, data);
        _tokenCounter++;
    }

    function mint() external onlyOwner {
        mint(msg.sender, 1, "");
    }

    function mint(address to) external onlyOwner {
        mint(to, 1, "");
    }

    function mint(
        address to,
        uint256 id,
        uint256 value,
        bytes memory data
    ) external onlyOwner {
        if (!exists(id)) {
            revert ERC1155Token__TokenDoesNotExist();
        }
        _mint(to, id, value, data);
    }

    function burn(uint256 id, uint256 value) external {
        _burn(msg.sender, id, value);
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        _setURI(baseURI);
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        string memory baseURI = uri(tokenId);
        return
            bytes(baseURI).length > 0
                ? string.concat(baseURI, tokenId.toString())
                : "";
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function setHasRoyalty(bool hasRoyalty) external onlyOwner {
        _hasRoyalty = hasRoyalty;
    }

    function setIsCommonRoyalty(bool isCommonRoyalty) external onlyOwner {
        _isCommonRoyalty = isCommonRoyalty;
    }

    function setRoyalties(
        uint256 tokenId,
        address payable[] calldata receivers,
        uint256[] calldata basisPoints
    ) external virtual onlyOwner {
        if (!_hasRoyalty) {
            revert ERC1155Token__RoyaltyIsOff();
        }
        if (!exists(tokenId)) {
            revert ERC1155Token__TokenDoesNotExist();
        }
        if (_isCommonRoyalty) {
            revert ERC1155Token__CommonRoyaltyIsOn();
        }

        _setRoyalties(tokenId, receivers, basisPoints);
    }

    function setRoyalties(
        address payable[] calldata receivers,
        uint256[] calldata basisPoints
    ) external virtual onlyOwner {
        if (!_hasRoyalty) {
            revert ERC1155Token__RoyaltyIsOff();
        }
        if (!_isCommonRoyalty) {
            revert ERC1155Token__CommonRoyaltyIsOff();
        }

        _setRoyalties(receivers, basisPoints);
    }

    function getRoyalties(
        uint256 tokenId
    )
        external
        view
        virtual
        returns (address payable[] memory, uint256[] memory)
    {
        if (!_hasRoyalty) {
            return (new address payable[](0), new uint256[](0));
        }
        if (!exists(tokenId)) {
            revert ERC1155Token__TokenDoesNotExist();
        }
        if (_isCommonRoyalty) {
            return getRoyalties();
        }

        return _getRoyalties(tokenId);
    }

    function getRoyalties()
        public
        view
        virtual
        returns (address payable[] memory, uint256[] memory)
    {
        if (!_hasRoyalty) {
            return (new address payable[](0), new uint256[](0));
        }
        if (!_isCommonRoyalty) {
            revert ERC1155Token__CommonRoyaltyIsOff();
        }

        return _getRoyalties();
    }
}
