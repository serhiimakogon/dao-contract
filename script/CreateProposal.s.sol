// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/DAOContract.sol";

/// @notice Deploy-time helper that submits a new DAO proposal using
/// the configured owner account.
contract CreateProposalScript is Script {
    function run() external {
        uint256 ownerKey = vm.envUint("PRIVATE_KEY");
        address daoAddress = vm.envAddress("DAO_CONTRACT_ADDRESS");
        string memory description = vm.envString("PROPOSAL_DESCRIPTION");

        DAOContract dao = DAOContract(daoAddress);
        address owner = vm.addr(ownerKey);
        uint256 proposalId = dao.proposalCount();

        vm.startBroadcast(ownerKey);
        dao.createProposal(description);
        vm.stopBroadcast();

        console.log("DAO:", daoAddress);
        console.log("Owner:", owner);
        console.log("Created proposal id:", proposalId);
        console.log("Description:", description);
    }
}
