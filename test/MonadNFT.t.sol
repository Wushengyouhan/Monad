// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/MonadNFT.sol";

contract BoykaNFTTest is Test {
    BoykaNFT public nft;
    address public owner;
    address public user1;
    address public user2;

    function setUp() public {
        owner = address(this);
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        nft = new BoykaNFT(owner);
    }

    function test_InitialState() public view {
        assertEq(nft.name(), "BoykaNFT");
        assertEq(nft.symbol(), "BNFT");
        assertEq(nft.owner(), owner);
    }

    function test_Mint() public {
        string memory uri = "ipfs://test1";
        nft.safeMint(user1, uri);

        assertEq(nft.ownerOf(0), user1);
        assertEq(nft.tokenURI(0), uri);
        assertEq(nft.balanceOf(user1), 1);
    }

    function test_MintNotOwner() public {
        vm.prank(user1);
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", user1));
        nft.safeMint(user1, "ipfs://test1");
    }

    function test_Enumerable() public {
        string memory uri1 = "ipfs://test1";
        string memory uri2 = "ipfs://test2";

        nft.safeMint(user1, uri1);
        nft.safeMint(user1, uri2);

        assertEq(nft.totalSupply(), 2);
        assertEq(nft.tokenByIndex(0), 0);
        assertEq(nft.tokenByIndex(1), 1);
        assertEq(nft.tokenOfOwnerByIndex(user1, 0), 0);
        assertEq(nft.tokenOfOwnerByIndex(user1, 1), 1);
    }

    function test_Burn() public {
        nft.safeMint(user1, "ipfs://test1");

        vm.prank(user1);
        nft.burn(0);

        vm.expectRevert(abi.encodeWithSignature("ERC721NonexistentToken(uint256)", 0));
        nft.ownerOf(0);
    }

    function test_Transfer() public {
        nft.safeMint(user1, "ipfs://test1");

        vm.prank(user1);
        nft.transferFrom(user1, user2, 0);

        assertEq(nft.ownerOf(0), user2);
        assertEq(nft.balanceOf(user1), 0);
        assertEq(nft.balanceOf(user2), 1);
    }
}
