// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.8.31;

import "forge-std/Script.sol";
import "../src/MyToken.sol";

contract DeployTokenMyToken is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        string memory name = "SMAK";
        string memory symbol = "SMAK";
        uint8 decimals_ = 12;
        uint256 totalSupply_ = 82_000_000;

        MyToken token = new MyToken(
            name,
            symbol,
            decimals_,
            totalSupply_
        );

        console.log("Token deployed at:", address(token));

        vm.stopBroadcast();
    }
}
