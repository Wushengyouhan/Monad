// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {BoykaNFT} from "../src/MonadNFT.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        BoykaNFT nft = new BoykaNFT(msg.sender);
        console.log("BoykaNFT deployed at:", address(nft));
    }
}
