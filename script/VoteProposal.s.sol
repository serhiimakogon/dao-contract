// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/DAOContract.sol";

/// @notice Votes on a DAO proposal according to env configuration.
contract VoteProposalScript is Script {
    function run() external {
        uint256 voterKey = vm.envUint("PRIVATE_KEY");
        address daoAddress = vm.envAddress("DAO_CONTRACT_ADDRESS");
        uint256 proposalId = vm.envUint("PROPOSAL_ID");
        bool support = vm.envBool("VOTE_SUPPORT");

        DAOContract dao = DAOContract(daoAddress);
        address voter = vm.addr(voterKey);

        vm.startBroadcast(voterKey);
        dao.voteOnProposal(proposalId, support);
        vm.stopBroadcast();

        console.log("DAO:", daoAddress);
        console.log("Voter:", voter);
        console.log("Proposal id:", proposalId);
        console.log("Support:", support);
    }
}
