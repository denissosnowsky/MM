// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

contract Royalty {
    error Royalty__InvalidInput();
    error Royalty__InvalidTotalRoyalties();
    error Royalty__NotValidReceiver();

    event RoyaltiesUpdated(
        uint256 indexed tokenId,
        address payable[] receivers,
        uint256[] basisPoints
    );
    event CommonRoyaltyUpdated(
        address payable[] receivers,
        uint256[] basisPoints
    );

    // Royalty configurations
    struct RoyaltyConfig {
        address payable receiver;
        uint16 bps;
    }

    mapping(uint256 => RoyaltyConfig[]) internal _tokenRoyalty;
    RoyaltyConfig[] private _commonRoyalty;

    /**
     * Set royalties for a token
     */
    function _setRoyalties(
        uint256 tokenId,
        address payable[] calldata receivers,
        uint256[] calldata basisPoints
    ) internal {
        _checkRoyalties(receivers, basisPoints);
        delete _tokenRoyalty[tokenId];
        _setRoyalties(receivers, basisPoints, _tokenRoyalty[tokenId]);
        emit RoyaltiesUpdated(tokenId, receivers, basisPoints);
    }

    /**
     * Set royalties for a all tokens
     */
    function _setRoyalties(
        address payable[] calldata receivers,
        uint256[] calldata basisPoints
    ) internal {
        _checkRoyalties(receivers, basisPoints);
        delete _commonRoyalty;
        _setRoyalties(receivers, basisPoints, _commonRoyalty);
        emit CommonRoyaltyUpdated(receivers, basisPoints);
    }

    /**
     * Helper function to check that royalties provided are valid
     */
    function _checkRoyalties(
        address payable[] calldata receivers,
        uint256[] calldata basisPoints
    ) private pure {
        if (receivers.length != basisPoints.length) {
            revert Royalty__InvalidInput();
        }

        uint256 totalBasisPoints;
        for (uint256 i; i < basisPoints.length; ) {
            if (receivers[i] == address(0)) {
                revert Royalty__NotValidReceiver();
            }
            totalBasisPoints += basisPoints[i];
            unchecked {
                ++i;
            }
        }

        if (totalBasisPoints >= 10000) {
            revert Royalty__InvalidTotalRoyalties();
        }
    }

    /**
     * Helper function to set royalties
     */
    function _setRoyalties(
        address payable[] calldata receivers,
        uint256[] calldata basisPoints,
        RoyaltyConfig[] storage royalties
    ) private {
        for (uint256 i; i < basisPoints.length; ) {
            royalties.push(
                RoyaltyConfig({
                    receiver: receivers[i],
                    bps: uint16(basisPoints[i])
                })
            );
            unchecked {
                ++i;
            }
        }
    }

    /**
     * Helper to get royalties for a token
     */
    function _getRoyalties(
        uint256 tokenId
    )
        internal
        view
        returns (address payable[] memory receivers, uint256[] memory bps)
    {
        RoyaltyConfig[] memory royalties = _tokenRoyalty[tokenId];
        if (royalties.length > 0) {
            (receivers, bps) = _getRoyaltiesFromConfig(royalties);
        }
    }

    /**
     * Helper to get royalties for all tokens
     */
    function _getRoyalties()
        internal
        view
        returns (address payable[] memory receivers, uint256[] memory bps)
    {
        RoyaltyConfig[] memory royalties = _commonRoyalty;
        if (royalties.length > 0) {
            (receivers, bps) = _getRoyaltiesFromConfig(royalties);
        }
    }

    function _getRoyaltiesFromConfig(
        RoyaltyConfig[] memory royalties
    )
        internal
        pure
        returns (address payable[] memory receivers, uint256[] memory bps)
    {
        receivers = new address payable[](royalties.length);
        bps = new uint256[](royalties.length);
        for (uint256 i; i < royalties.length; ) {
            receivers[i] = royalties[i].receiver;
            bps[i] = royalties[i].bps;
            unchecked {
                ++i;
            }
        }
    }
}
