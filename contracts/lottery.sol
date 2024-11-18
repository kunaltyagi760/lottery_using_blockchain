// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Lottery{
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor(){
        manager = msg.sender;
    }

    function participate() public payable {
        require(msg.value == 1 ether, "Please pay 1 ether to participate!");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(manager == msg.sender, "You are not manager.");
        return address(this).balance;
    }

    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }

    function pickWinner() public returns(address){
        require(manager == msg.sender, "You are not manager");
        require(players.length >= 3);

        uint index = random();
        index %= 3;
        winner = players[index];
        winner.transfer(getBalance());
        players = new address payable[](0);
        return winner;
    }

}