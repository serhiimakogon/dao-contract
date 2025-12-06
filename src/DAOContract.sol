// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract DAOContract is Ownable {
    enum ProposalStatus {
        Pending,
        Active,
        Executed
    }

    struct Proposal {
        uint256 id;
        string description;
        address creator;
        ProposalStatus status;
        uint256 forVotes;
        uint256 againstVotes;
        uint64 createdAt;
        uint64 updatedAt;
        address executor;
    }

    uint256 public proposalCount;

    Proposal[] private inMemoryProposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ProposalCreated(uint256 indexed id, string description, address indexed creator);
    event Voted(
        uint256 indexed id,
        bool support,
        address indexed voter,
        uint256 forVotes,
        uint256 againstVotes,
        ProposalStatus status
    );
    event ProposalExecuted(uint256 indexed id, address indexed executor);

    constructor(address initialOwner) Ownable(initialOwner) {}

    function createProposal(string memory _description) external onlyOwner {
        require(bytes(_description).length > 0, "Description cannot be empty");

        uint256 id = proposalCount;

        Proposal memory newProposal = Proposal({
            id: id,
            description: _description,
            creator: msg.sender,
            status: ProposalStatus.Pending,
            forVotes: 0,
            againstVotes: 0,
            createdAt: uint64(block.timestamp),
            updatedAt: uint64(block.timestamp),
            executor: address(0)
        });

        inMemoryProposals.push(newProposal);
        proposalCount++;

        emit ProposalCreated(id, _description, msg.sender);
    }

    function voteOnProposal(uint256 _id, bool support) external {
        require(_id < proposalCount, "Proposal does not exist");

        Proposal storage proposal = inMemoryProposals[_id];
        require(proposal.status != ProposalStatus.Executed, "Proposal already executed");
        require(!hasVoted[_id][msg.sender], "Already voted");

        hasVoted[_id][msg.sender] = true;

        if (support) {
            proposal.forVotes += 1;
        } else {
            proposal.againstVotes += 1;
        }

        if (proposal.status == ProposalStatus.Pending) {
            proposal.status = ProposalStatus.Active;
        }

        proposal.updatedAt = uint64(block.timestamp);

        emit Voted(_id, support, msg.sender, proposal.forVotes, proposal.againstVotes, proposal.status);
    }

    function executeProposal(uint256 _id) external onlyOwner {
        require(_id < proposalCount, "Proposal does not exist");

        Proposal storage proposal = inMemoryProposals[_id];
        require(proposal.status != ProposalStatus.Executed, "Proposal already executed");
        require(proposal.forVotes > proposal.againstVotes, "Proposal did not pass");
        require(proposal.forVotes > 0, "No support");

        proposal.status = ProposalStatus.Executed;
        proposal.executor = msg.sender;
        proposal.updatedAt = uint64(block.timestamp);

        emit ProposalExecuted(_id, msg.sender);
    }

    function getProposal(uint256 _id) external view returns (Proposal memory) {
        require(_id < proposalCount, "Proposal does not exist");

        return inMemoryProposals[_id];
    }

    function getAllProposals() external view returns (Proposal[] memory) {
        Proposal[] memory proposalList = new Proposal[](proposalCount);
        for (uint256 i = 0; i < proposalCount; i++) {
            proposalList[i] = inMemoryProposals[i];
        }
        return proposalList;
    }
}
