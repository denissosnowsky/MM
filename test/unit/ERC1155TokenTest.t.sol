// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {ERC1155Token} from "../../src/tokens/ERC1155Token.sol";
import {Royalty} from "../../src/extentions/Royalty.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract ERC1155TokenTest is Test {
    using Strings for uint256;

    ERC1155Token token;

    address public USER = makeAddr("user");
    address public USER2 = makeAddr("user2");
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    function setUp() external {
        token = new ERC1155Token();
        token.initialize("name", "symbol", "baseUri", USER, true);
        vm.deal(USER, STARTING_USER_BALANCE);
        vm.deal(USER2, STARTING_USER_BALANCE);
    }

    function testTokenHasCorrectName() public {
        assertEq(token.name(), "name");
    }

    function testTokenHasCorrectSymbol() public {
        assertEq(token.symbol(), "symbol");
    }

    function testTokenHasCorrectUri() public {
        uint256 id = 0;

        vm.prank(USER);
        token.mint();

        assertEq(token.tokenURI(id), string.concat("baseUri", id.toString()));
    }

    function testTokenHasCorrectOwner() public {
        assertEq(token.owner(), USER);
    }

    function testIsInitialized() public {
        vm.prank(USER);
        vm.expectRevert(ERC1155Token.ERC1155Token__AlreadyInitialized.selector);
        token.initialize("", "", "", address(0), true);
    }

    function testNotOwnerCannotCallWriteFunctions() public {
        bytes memory revertError = abi.encodeWithSelector(
            Ownable.OwnableUnauthorizedAccount.selector,
            USER2
        );

        vm.prank(USER);
        token.mint();

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

    function testOwnerMint() public {
        vm.startPrank(USER);
        token.mint();
        token.mint();
        token.mint(USER, 100, "");
        token.mint(USER2);
        vm.stopPrank();

        assertEq(token.balanceOf(USER, 0), 1);
        assertEq(token.balanceOf(USER, 1), 1);
        assertEq(token.balanceOf(USER, 2), 100);
        assertEq(token.balanceOf(USER2, 3), 1);
        assertEq(token.totalSupply(0), 1);
        assertEq(token.totalSupply(1), 1);
        assertEq(token.totalSupply(3), 1);
        assertEq(token.totalSupply(2), 100);
        assertEq(token.totalSupply(), 103);
    }

    function testCannotMintAmountToNotExistedToken() public {
        vm.prank(USER);
        vm.expectRevert(ERC1155Token.ERC1155Token__TokenDoesNotExist.selector);
        token.mint(USER, 1, 100, "");
    }

    function testAnyoneCanBurnOnlyOwnTokens() public {
        vm.startPrank(USER);
        token.mint();
        token.mint();
        token.mint(USER2);
        vm.stopPrank();

        vm.prank(USER);
        token.burn(0, 1);

        vm.expectRevert();
        vm.prank(USER);
        token.burn(2, 1);

        vm.expectRevert();
        vm.prank(USER2);
        token.burn(1, 1);

        vm.prank(USER2);
        token.burn(2, 1);

        assertEq(token.balanceOf(USER, 0), 0);
        assertEq(token.balanceOf(USER, 1), 1);
        assertEq(token.balanceOf(USER2, 2), 0);
    }

    function testOwnerChangeSetBaseUri() public {
        uint256 id = 0;

        vm.prank(USER);
        token.mint();

        assertEq(token.tokenURI(id), string.concat("baseUri", id.toString()));

        vm.prank(USER);
        token.setBaseURI("newBaseUri");

        assertEq(
            token.tokenURI(id),
            string.concat("newBaseUri", id.toString())
        );
    }

    function testHasCommonRoayltyByDefault() public {
        vm.startPrank(USER);
        token.mint();
        address payable[] memory receivers = new address payable[](0);
        uint256[] memory bps = new uint256[](0);

        vm.expectRevert(ERC1155Token.ERC1155Token__CommonRoyaltyIsOn.selector);
        token.setRoyalties(0, receivers, bps);

        token.setRoyalties(receivers, bps);

        token.getRoyalties();
        vm.stopPrank();
    }

    function testOwnerCanChangeHasCommonRoyalty() public {
        vm.startPrank(USER);

        token.setIsCommonRoyalty(false);

        token.mint();
        address payable[] memory receivers = new address payable[](0);
        uint256[] memory bps = new uint256[](0);

        token.setRoyalties(0, receivers, bps);

        vm.expectRevert(ERC1155Token.ERC1155Token__CommonRoyaltyIsOff.selector);
        token.setRoyalties(receivers, bps);
        vm.expectRevert(ERC1155Token.ERC1155Token__CommonRoyaltyIsOff.selector);
        token.getRoyalties();
        vm.stopPrank();
    }

    function testOwnerCanChangeHasRoyalty() public {
        vm.startPrank(USER);
        token.mint();
        address payable[] memory receivers = new address payable[](0);
        uint256[] memory bps = new uint256[](0);

        token.setRoyalties(receivers, bps);

        token.setHasRoyalty(false);

        vm.expectRevert(ERC1155Token.ERC1155Token__RoyaltyIsOff.selector);
        token.setRoyalties(receivers, bps);
        vm.expectRevert(ERC1155Token.ERC1155Token__RoyaltyIsOff.selector);
        token.setRoyalties(0, receivers, bps);
        vm.stopPrank();
    }

    function testOwnerCanSetCommonRoyalties() public {
        vm.startPrank(USER);
        token.mint();

        address payable[] memory receivers = new address payable[](2);
        receivers[0] = payable(USER);
        receivers[1] = payable(USER2);
        uint256[] memory bps = new uint256[](2);
        bps[0] = 100;
        bps[1] = 200;

        token.setRoyalties(receivers, bps);

        (address payable[] memory receiversRes, uint256[] memory bpsRes) = token
            .getRoyalties();

        assertEq(receiversRes.length, 2);
        assertEq(bpsRes.length, 2);
        assertEq(receiversRes[0], USER);
        assertEq(receiversRes[1], USER2);
        assertEq(bpsRes[0], 100);
        assertEq(bpsRes[1], 200);

        (
            address payable[] memory receiversResValues,
            uint256[] memory bpsResValues
        ) = token.royaltyInfo(10000);
        assertEq(receiversResValues.length, 2);
        assertEq(bpsResValues.length, 2);
        assertEq(receiversResValues[0], USER);
        assertEq(receiversResValues[1], USER2);
        assertEq(bpsResValues[0], 100);
        assertEq(bpsResValues[1], 200);

        (
            address payable[] memory receiversResValues2,
            uint256[] memory bpsResValues2
        ) = token.royaltyInfo(0, 10000);
        assertEq(receiversResValues2.length, 2);
        assertEq(bpsResValues2.length, 2);
        assertEq(receiversResValues2[0], USER);
        assertEq(receiversResValues2[1], USER2);
        assertEq(bpsResValues2[0], 100);
        assertEq(bpsResValues2[1], 200);

        // Reset to new
        address payable[] memory receivers2 = new address payable[](1);
        receivers2[0] = payable(USER);
        uint256[] memory bps2 = new uint256[](1);
        bps2[0] = 100;

        token.setRoyalties(receivers2, bps2);

        (
            address payable[] memory receiversRes2,
            uint256[] memory bpsRes2
        ) = token.getRoyalties();

        assertEq(receiversRes2.length, 1);
        assertEq(bpsRes2.length, 1);
        assertEq(receiversRes2[0], USER);
        assertEq(bpsRes2[0], 100);

        vm.stopPrank();
    }

    function testOwnerCanSetIndividualRoyaltiesForEachToken() public {
        vm.startPrank(USER);
        token.mint();
        token.mint();

        token.setIsCommonRoyalty(false);

        address payable[] memory receivers = new address payable[](2);
        receivers[0] = payable(USER);
        receivers[1] = payable(USER2);
        uint256[] memory bps = new uint256[](2);
        bps[0] = 100;
        bps[1] = 200;

        token.setRoyalties(0, receivers, bps);

        (address payable[] memory receiversRes, uint256[] memory bpsRes) = token
            .getRoyalties(0);

        assertEq(receiversRes.length, 2);
        assertEq(bpsRes.length, 2);
        assertEq(receiversRes[0], USER);
        assertEq(receiversRes[1], USER2);
        assertEq(bpsRes[0], 100);
        assertEq(bpsRes[1], 200);

        (
            address payable[] memory receiversResValues,
            uint256[] memory bpsResValues
        ) = token.royaltyInfo(0, 10000);
        assertEq(receiversResValues.length, 2);
        assertEq(bpsResValues.length, 2);
        assertEq(receiversResValues[0], USER);
        assertEq(receiversResValues[1], USER2);
        assertEq(bpsResValues[0], 100);
        assertEq(bpsResValues[1], 200);

        // Reset to new
        address payable[] memory receivers2 = new address payable[](1);
        receivers2[0] = payable(USER);
        uint256[] memory bps2 = new uint256[](1);
        bps2[0] = 100;

        token.setRoyalties(1, receivers2, bps2);

        (
            address payable[] memory receiversRes2,
            uint256[] memory bpsRes2
        ) = token.getRoyalties(1);

        assertEq(receiversRes2.length, 1);
        assertEq(bpsRes2.length, 1);
        assertEq(receiversRes2[0], USER);
        assertEq(bpsRes2[0], 100);

        vm.stopPrank();
    }

    function testCantAddRoyaltyToNotMintedToken() public {
        vm.startPrank(USER);
        address payable[] memory receivers = new address payable[](2);
        receivers[0] = payable(USER);
        receivers[1] = payable(USER2);
        uint256[] memory bps = new uint256[](2);
        bps[0] = 100;
        bps[1] = 200;

        vm.expectRevert(ERC1155Token.ERC1155Token__TokenDoesNotExist.selector);
        token.setRoyalties(0, receivers, bps);
        vm.stopPrank();
    }

    function testShouldReturnCommonRoyaltyForOneTokenWhenCommonRoyaltyIsOn()
        public
    {
        vm.startPrank(USER);
        token.mint();
        token.mint();

        token.setIsCommonRoyalty(false);

        address payable[] memory receivers = new address payable[](2);
        receivers[0] = payable(USER);
        receivers[1] = payable(USER2);
        uint256[] memory bps = new uint256[](2);
        bps[0] = 100;
        bps[1] = 200;

        token.setRoyalties(0, receivers, bps);

        (address payable[] memory receiversRes, uint256[] memory bpsRes) = token
            .getRoyalties(0);

        assertEq(receiversRes.length, 2);
        assertEq(bpsRes.length, 2);
        assertEq(receiversRes[0], USER);
        assertEq(receiversRes[1], USER2);
        assertEq(bpsRes[0], 100);
        assertEq(bpsRes[1], 200);

        token.setIsCommonRoyalty(true);

        (
            address payable[] memory receiversRes2,
            uint256[] memory bpsRes2
        ) = token.getRoyalties(0);

        assertEq(receiversRes2.length, 0);
        assertEq(bpsRes2.length, 0);

        token.setIsCommonRoyalty(false);

        (
            address payable[] memory receiversRes3,
            uint256[] memory bpsRes3
        ) = token.getRoyalties(0);

        assertEq(receiversRes3.length, 2);
        assertEq(bpsRes3.length, 2);
        assertEq(receiversRes3[0], USER);
        assertEq(receiversRes3[1], USER2);
        assertEq(bpsRes3[0], 100);
        assertEq(bpsRes3[1], 200);

        vm.stopPrank();
    }

    function testShouldReturnEmptyRoyaltiesWhenTherAreSwtichedOff() public {
        vm.startPrank(USER);
        token.mint();

        token.setHasRoyalty(false);

        (address payable[] memory receiversRes, uint256[] memory bpsRes) = token
            .getRoyalties(0);

        assertEq(receiversRes.length, 0);
        assertEq(bpsRes.length, 0);

        (
            address payable[] memory receiversRes2,
            uint256[] memory bpsRes2
        ) = token.getRoyalties();

        assertEq(receiversRes2.length, 0);
        assertEq(bpsRes2.length, 0);

        token.setIsCommonRoyalty(false);
        vm.stopPrank();
    }

    function testShouldRevertOnWrongRoyalty() public {
        vm.startPrank(USER);
        token.mint();

        address payable[] memory receivers = new address payable[](2);
        receivers[0] = payable(USER);
        receivers[1] = payable(USER2);
        uint256[] memory bps = new uint256[](2);
        bps[0] = 10000;
        bps[1] = 200;

        vm.expectRevert(Royalty.Royalty__InvalidTotalRoyalties.selector);
        token.setRoyalties(receivers, bps);

        vm.stopPrank();
    }

    function testShouldRevertOnWrongRoyaltyAddress() public {
        vm.startPrank(USER);
        token.mint();

        address payable[] memory receivers = new address payable[](2);
        receivers[0] = payable(USER);
        receivers[1] = payable(address(0));
        uint256[] memory bps = new uint256[](2);
        bps[0] = 100;
        bps[1] = 200;

        vm.expectRevert(Royalty.Royalty__NotValidReceiver.selector);
        token.setRoyalties(receivers, bps);

        vm.stopPrank();
    }

    function testShouldRevertOnWrongRoyaltyAndAddressLength() public {
        vm.startPrank(USER);
        token.mint();

        address payable[] memory receivers = new address payable[](1);
        receivers[0] = payable(USER);
        uint256[] memory bps = new uint256[](2);
        bps[0] = 100;
        bps[1] = 200;

        vm.expectRevert(Royalty.Royalty__InvalidInput.selector);
        token.setRoyalties(receivers, bps);

        vm.stopPrank();
    }
}
