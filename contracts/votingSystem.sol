// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract VotingSystem{
    address public owner;

    struct Candidate{
        address candidateAddr;
        uint voteCount;
    }

    Candidate[] public candidates;

    address[] public voters;

    constructor(){
        owner = msg.sender;
    }

    modifier validateOwner() {
        require(msg.sender == owner, "Not Owner");
        _;
    }

    modifier validateCandidateAddr(address _candidateAddr) {
        bool alreadyAdded = false;

        for (uint i=0; i<candidates.length; i++){
            if (candidates[i].candidateAddr == _candidateAddr){
                alreadyAdded = true;
                break;
            }
        }

        require(!alreadyAdded, "Candidate Already Added");
        _;
    }

    modifier validateVoter() {
        bool alreadyVoted = false;

        for(uint i=0; i<voters.length; i++){
            if (voters[i] == msg.sender){
                alreadyVoted = true;
                break;
            }
        }

        require(!alreadyVoted, "You have already given your vote.");
        _;
    }

    function addCandidate(address _candidateAddr) public validateOwner validateCandidateAddr(_candidateAddr) {
        candidates.push(Candidate({candidateAddr: _candidateAddr, voteCount: 0}));
    }

    function vote(address _candidateAddr) public validateVoter {
        bool candidateFound = false;

        for(uint i=0; i<candidates.length; i++){
            if (candidates[i].candidateAddr == _candidateAddr){
                candidates[i].voteCount += 1;
                candidateFound = true;
                break;
            }
        }

        require(candidateFound, "Candidate not found!");

        voters.push(msg.sender);
    }

    function getVoteCount(address _candidateAddr) public validateOwner view returns(uint candidateVoteCount) {
        bool candidateFound = false;

        for (uint i=0; i<candidates.length; i++){
            if (candidates[i].candidateAddr == _candidateAddr){
                candidateVoteCount = candidates[i].voteCount;
                candidateFound = true;
                break;
            }
        }

        require(candidateFound, "Candidate not found!");
        
        return candidateVoteCount;
    }

}





