// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract VotingSystem{
    address public owner;

    struct Candidate{
        uint voteCount;
        bool exists;
    }

    mapping(address => Candidate) public candidates;
    mapping(address => bool) public voters;

    event CandidateAdded(address candidateAddr);
    event Voted(address voter, address candidateAddr);

    constructor(){
        owner = msg.sender;
    }

    modifier validateOwner() {
        require(msg.sender == owner, "Not Owner");
        _;
    }

    modifier validateCandidateAddr(address _candidateAddr) {

        require(!candidates[_candidateAddr].exists, "Candidate Already Added!");
        _;
    }

    modifier validateVoter() {

        require(!voters[msg.sender], "You have already voted.");
        _;
    }

    modifier validateCandidate(address _candidateAddr) {

        require(candidates[_candidateAddr].exists, "Candidate not found!");
        _;
    }

    function addCandidate(address _candidateAddr) public validateOwner validateCandidateAddr(_candidateAddr) {
        candidates[_candidateAddr] = Candidate({voteCount: 0, exists: true});
        emit CandidateAdded(_candidateAddr);
    }

    function vote(address _candidateAddr) public validateVoter validateCandidate(_candidateAddr) {
        
        candidates[_candidateAddr].voteCount += 1;
        voters[msg.sender] = true;

        emit Voted(msg.sender, _candidateAddr);
    }

    function getVoteCount(address _candidateAddr) public validateCandidate(_candidateAddr) view returns(uint) {
        
        return candidates[_candidateAddr].voteCount;
    }

}
