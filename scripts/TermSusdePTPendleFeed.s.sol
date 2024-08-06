// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import "forge-std/Script.sol";
import "../contracts/oracle/TermSusdePTPendleFeed.sol";

contract TermSusdePTPendleFeedScript is Script {
    constructor() Script() {}

    function run() external {
        uint256 deployerPK = vm.envUint("PRIVATE_KEY");

        // Set up the RPC URL (optional if you're using the default foundry config)
        string memory rpcUrl = vm.envString("RPC_URL");

        vm.startBroadcast(deployerPK);

        // Retrieve environment variables
        address usdePriceFeed = vm.envAddress("USDE_PRICE_FEED");

        TermSusdePTPendleFeed myContract = new TermSusdePTPendleFeed(250000000000000000, 1800, usdePriceFeed);

        console.log("TermSusdePTPendleFeed deployed to:", address(myContract));

        vm.stopBroadcast();
    }
}