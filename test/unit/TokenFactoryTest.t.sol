// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {TokenFactory} from "../../src/TokenFactory.sol";
import {ERC721Token} from "../../src/tokens/ERC721Token.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC1155Token} from "../../src/tokens/ERC1155Token.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TokenFactoryTest is Test {
    event TokenCreated(address token, bool isERC721);

    using Strings for uint256;

    TokenFactory factory;

    address public USER = makeAddr("user");
    address public USER2 = makeAddr("user2");
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    function setUp() external {
        factory = new TokenFactory();
        vm.deal(USER, STARTING_USER_BALANCE);
        vm.deal(USER2, STARTING_USER_BALANCE);
    }

    function testShouldCreateERC721TokenWithCorrectConfig() public {
        vm.startPrank(USER);
        vm.expectEmit(false, true, false, false);
        emit TokenCreated(address(0), true);
        ERC721Token token = ERC721Token(
            factory.createToken(true, "name", "symbol", "URI", true)
        );
        vm.stopPrank();

        assertEq(token.owner(), USER);
        assertEq(token.name(), "name");
        assertEq(token.symbol(), "symbol");

        uint256 id = 0;

        vm.prank(USER);
        token.mint();

        assertEq(token.tokenURI(id), string.concat("URI", id.toString()));

        assertEq(factory.getTokens(USER)[0], address(token));
        assertEq(factory.getTokens(USER).length, 1);
        vm.startPrank(USER);
        assertEq(factory.getTokens()[0], address(token));

        ERC721Token newToken = ERC721Token(
            factory.createToken(true, "name", "symbol", "URI", true)
        );

        assertEq(factory.getTokens(USER)[0], address(token));
        assertEq(factory.getTokens(USER)[1], address(newToken));
        assertEq(factory.getTokens(USER).length, 2);
        vm.startPrank(USER);
        assertEq(factory.getTokens()[1], address(newToken));
    }

    function testShouldERC721TokenOwnableIsCorrect() public {
        vm.startPrank(USER);
        vm.expectEmit(false, true, false, false);
        emit TokenCreated(address(0), true);
        ERC721Token token = ERC721Token(
            factory.createToken(true, "name", "symbol", "URI", true)
        );
        vm.stopPrank();

        bytes memory revertError = abi.encodeWithSelector(
            Ownable.OwnableUnauthorizedAccount.selector,
            USER2
        );

        vm.startPrank(USER2);
        vm.expectRevert(ERC721Token.ERC721Token__AlreadyInitialized.selector);
        token.initialize("", "", "", address(0), true);
        vm.expectRevert(revertError);
        token.mint();
        vm.expectRevert(revertError);
        token.mint(address(0));
        vm.expectRevert(revertError);
        token.setBaseURI("");
        vm.expectRevert(revertError);
        token.setHasRoyalty(false);
        vm.expectRevert(revertError);
        token.setIsCommonRoyalty(false);
        vm.expectRevert(revertError);
        address payable[] memory receivers = new address payable[](0);
        uint256[] memory bps = new uint256[](0);
        token.setRoyalties(0, receivers, bps);
        vm.expectRevert(revertError);
        token.setRoyalties(receivers, bps);
        vm.stopPrank();
    }

    function testShouldCreateERC1155TokenWithCorrectConfig() public {
        vm.startPrank(USER);
        vm.expectEmit(false, true, false, false);
        emit TokenCreated(address(0), true);
        ERC1155Token token = ERC1155Token(
            factory.createToken(true, "name", "symbol", "URI", true)
        );
        vm.stopPrank();

        assertEq(token.owner(), USER);
        assertEq(token.name(), "name");
        assertEq(token.symbol(), "symbol");

        uint256 id = 0;

        vm.prank(USER);
        token.mint();

        assertEq(token.tokenURI(id), string.concat("URI", id.toString()));

        assertEq(factory.getTokens(USER)[0], address(token));
        assertEq(factory.getTokens(USER).length, 1);
        vm.startPrank(USER);
        assertEq(factory.getTokens()[0], address(token));

        ERC1155Token newToken = ERC1155Token(
            factory.createToken(true, "name", "symbol", "URI", true)
        );

        assertEq(factory.getTokens(USER)[0], address(token));
        assertEq(factory.getTokens(USER)[1], address(newToken));
        assertEq(factory.getTokens(USER).length, 2);
        vm.startPrank(USER);
        assertEq(factory.getTokens()[1], address(newToken));
    }

    function testShouldERC1155TokenOwnableIsCorrect() public {
        vm.startPrank(USER);
        vm.expectEmit(false, false, false, false);
        emit TokenCreated(address(0), true);
        ERC1155Token token = ERC1155Token(
            factory.createToken(false, "name", "symbol", "URI", true)
        );
        vm.stopPrank();

        bytes memory revertError = abi.encodeWithSelector(
            Ownable.OwnableUnauthorizedAccount.selector,
            USER2
        );

        vm.startPrank(USER2);
        vm.expectRevert(ERC1155Token.ERC1155Token__AlreadyInitialized.selector);
        token.initialize("", "", "", address(0), true);
        vm.expectRevert(revertError);
        token.mint();
        vm.expectRevert(revertError);
        token.mint(USER);
        vm.expectRevert(revertError);
        token.mint(address(0), 2, "");
        vm.expectRevert(revertError);
        token.mint(address(0), 0, 2, "");
        vm.expectRevert(revertError);
        token.setBaseURI("");
        vm.expectRevert(revertError);
        token.setHasRoyalty(false);
        vm.expectRevert(revertError);
        token.setIsCommonRoyalty(false);
        vm.expectRevert(revertError);
        address payable[] memory receivers = new address payable[](0);
        uint256[] memory bps = new uint256[](0);
        token.setRoyalties(0, receivers, bps);
        vm.expectRevert(revertError);
        token.setRoyalties(receivers, bps);
        vm.stopPrank();
    }

    function testExternalUserCantUpgradeTokensImplementations() public {
        vm.startPrank(USER);
        ERC1155Token(factory.createToken(false, "name", "symbol", "URI", true));
        ERC721Token(factory.createToken(false, "name", "symbol", "URI", true));
        vm.stopPrank();

        vm.startPrank(USER2);
        address newToken = address(new ERC721Token());

        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                USER2
            )
        );
        factory.upgradeBeaconERC721(newToken);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                USER2
            )
        );
        factory.upgradeBeaconERC1155(newToken);
        vm.stopPrank();
    }

    function testFactoryOwnerCanUprgradeTokensImplementations() public {
        vm.startPrank(USER);
        ERC1155Token(factory.createToken(false, "name", "symbol", "URI", true));
        ERC721Token(factory.createToken(false, "name", "symbol", "URI", true));
        vm.stopPrank();

        address newToken721 = address(new ERC721Token());
        address newToken1155 = address(new ERC1155Token());

        factory.upgradeBeaconERC721(newToken721);
        factory.upgradeBeaconERC1155(newToken1155);
    }
}
