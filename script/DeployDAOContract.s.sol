// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/DAOContract.sol";

contract DeployDAOContract is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        DAOContract dao = new DAOContract(owner);

        console.log("DAO contract deployed at:", address(dao));
        console.log("Initial owner:", owner);

        vm.stopBroadcast();
    }
}
