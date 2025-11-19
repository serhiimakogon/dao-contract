// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract DAOContract is Ownable {
    struct Proposal {
        uint256 id;
        string description;
        bool executed;
    }

    uint256 public proposalCount;

    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 id, address creator, string description);
    event ProposalExecuted(uint256 id, address executor);

    constructor(address initialOwner) Ownable(initialOwner) {}

    function createProposal(string memory _description) external onlyOwner {
        require(bytes(_description).length > 0, "Description cannot be empty");

        uint256 id = proposalCount;

        proposals[id] = Proposal({
            id: id,
            description: _description,
            executed: false
        });

        proposalCount++;

        emit ProposalCreated(id, msg.sender, _description);
    }

    function executeProposal(uint256 _id) external onlyOwner {
        require(_id < proposalCount, "Proposal does not exist");

        Proposal storage proposal = proposals[_id];
        require(!proposal.executed, "Proposal already executed");

        proposal.executed = true;

        emit ProposalExecuted(_id, msg.sender);
    }

    function getProposal(uint256 _id) external view returns (uint256 id, string memory description, bool executed) {
        require(_id < proposalCount, "Proposal does not exist");

        Proposal memory proposal = proposals[_id];
        return (proposal.id, proposal.description, proposal.executed);
    }
}
