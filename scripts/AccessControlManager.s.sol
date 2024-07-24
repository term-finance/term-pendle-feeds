// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import "forge-std/Script.sol";
import "../contracts/AccessControlManager.sol";

contract AcccessControlManagerScript is Script {
    constructor() Script() {}

    function run() external {
        uint256 deployerPK = vm.envUint("PRIVATE_KEY");

        // Set up the RPC URL (optional if you're using the default foundry config)
        string memory rpcUrl = vm.envString("RPC_URL");

        vm.startBroadcast(deployerPK);

        vm.startBroadcast();

        AccessControlManager myContract = new AccessControlManager();

        console.log("AccessControlManager deployed to:", address(myContract));

        vm.stopBroadcast();
    }
}