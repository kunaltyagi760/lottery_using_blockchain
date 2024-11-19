// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0

import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.25;

contract VotingSystem is Ownable{

    struct Candidate{
        uint voteCount;
        bool exists;
    }

    mapping(address => Candidate) public candidates;
    mapping(address => bool) public voters;
    address[] public candidateList;

    event CandidateAdded(address candidateAddr);
    event Voted(address voter, address candidateAddr);

    constructor() Ownable(msg.sender) {}

    function addCandidate(address _candidateAddr) public onlyOwner {

        require(!candidates[_candidateAddr].exists, "Candidate Already Added!");

        candidates[_candidateAddr] = Candidate({voteCount: 0, exists: true});
        candidateList.push(_candidateAddr);
        emit CandidateAdded(_candidateAddr);
    }

    function vote(address _candidateAddr) public {

        require(!voters[msg.sender], "You have already voted.");
        require(candidates[_candidateAddr].exists, "Candidate not found!");
        
        candidates[_candidateAddr].voteCount += 1;
        voters[msg.sender] = true;

        emit Voted(msg.sender, _candidateAddr);
    }

    function getter() public view returns(address[] memory){
        return candidateList;
    }

}
