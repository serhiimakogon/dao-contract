// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/DAOContract.sol";

/// @notice Executes a passed DAO proposal using the owner account.
contract ExecuteProposalScript is Script {
    function run() external {
        uint256 ownerKey = vm.envUint("PRIVATE_KEY");
        address daoAddress = vm.envAddress("DAO_CONTRACT_ADDRESS");
        uint256 proposalId = vm.envUint("PROPOSAL_ID");

        DAOContract dao = DAOContract(daoAddress);
        address owner = vm.addr(ownerKey);

        vm.startBroadcast(ownerKey);
        dao.executeProposal(proposalId);
        vm.stopBroadcast();

        console.log("DAO:", daoAddress);
        console.log("Owner:", owner);
        console.log("Executed proposal id:", proposalId);
    }
}
