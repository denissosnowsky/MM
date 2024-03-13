// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {ERC721} from "../standarts/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Royalty} from "../extensions/Royalty.sol";
import {IToken} from "./IToken.sol";

contract ERC721Token is Ownable, ERC721, Royalty, IToken {
    error ERC721Token__TokenDoesNotExist();
    error ERC721Token__RoyaltyIsOff();
    error ERC721Token__CommonRoyaltyIsOn();
    error ERC721Token__CommonRoyaltyIsOff();
    error ERC721Token__AlreadyInitialized();
    error ERC721Token__NotTokenOwner();

    bool private _initialized;
    uint256 private _tokenCounter;
    string private _baseTokenURI;
    // flag to swtich on/off royalties
    bool private _hasRoyalty;
    /**
     * flag to show one general royalty for all tokens
     * or individual royalties for each token
     */
    bool private _isCommonRoyalty;

    constructor() ERC721("", "") Ownable(msg.sender) {
        if (_initialized) {
            revert ERC721Token__AlreadyInitialized();
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
            revert ERC721Token__AlreadyInitialized();
        }

        setInitialized();
        _name = name_;
        _symbol = symbol_;
        _baseTokenURI = baseTokenURI_;
        _hasRoyalty = hasRoyalty_;
        _isCommonRoyalty = true;
        _transferOwnership(initialOwner_);
    }

    function setInitialized() public {
        _initialized = true;
    }

    function mint() external onlyOwner {
        _safeMint(msg.sender, _tokenCounter);
        _tokenCounter++;
    }

    function mint(address to) external onlyOwner {
        _safeMint(to, _tokenCounter);
        _tokenCounter++;
    }

    function burn(uint256 tokenId) external {
        if (msg.sender != ownerOf(tokenId)) {
            revert ERC721Token__NotTokenOwner();
        }

        _burn(tokenId);
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
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
            revert ERC721Token__RoyaltyIsOff();
        }
        if (!_exists(tokenId)) {
            revert ERC721Token__TokenDoesNotExist();
        }
        if (_isCommonRoyalty) {
            revert ERC721Token__CommonRoyaltyIsOn();
        }

        _setRoyalties(tokenId, receivers, basisPoints);
    }

    function setRoyalties(
        address payable[] calldata receivers,
        uint256[] calldata basisPoints
    ) external virtual onlyOwner {
        if (!_hasRoyalty) {
            revert ERC721Token__RoyaltyIsOff();
        }
        if (!_isCommonRoyalty) {
            revert ERC721Token__CommonRoyaltyIsOff();
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
        if (!_exists(tokenId)) {
            revert ERC721Token__TokenDoesNotExist();
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
            revert ERC721Token__CommonRoyaltyIsOff();
        }

        return _getRoyalties();
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }
}
