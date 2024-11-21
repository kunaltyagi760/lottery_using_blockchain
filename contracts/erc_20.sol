// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20Token {
    string public name = "MyToken"; 
    string public symbol = "MTK";   
    uint8 public decimals = 18;     
    
    uint256 public totalSupply;     

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10 ** uint256(decimals); // Adjust for decimals
        balanceOf[msg.sender] = totalSupply; // Allocate all tokens to the creator
    }

    // Transfer function to move tokens from sender to recipient
    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(balanceOf[msg.sender] >= amount, "ERC20: insufficient balance");

        balanceOf[msg.sender] -= amount;  // Decrease sender's balance
        balanceOf[to] += amount;          // Increase recipient's balance

        emit Transfer(msg.sender, to, amount); // Emit the transfer event
        return true;
    }

    // Approve function to allow a spender to spend a specified amount of tokens
    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "ERC20: approve to the zero address");

        allowance[msg.sender][spender] = amount; // Set the allowance
        emit Approval(msg.sender, spender, amount); // Emit approval event
        return true;
    }

    // TransferFrom function to allow a spender to transfer tokens from one account to another
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(balanceOf[from] >= amount, "ERC20: insufficient balance");
        require(allowance[from][msg.sender] >= amount, "ERC20: allowance exceeded");

        balanceOf[from] -= amount;            // Decrease the balance of the sender
        balanceOf[to] += amount;              // Increase the balance of the recipient
        allowance[from][msg.sender] -= amount; // Decrease the allowance

        emit Transfer(from, to, amount); // Emit the transfer event
        return true;
    }

    // Function to check the allowance given to a spender by an owner
    function getAllowance(address owner, address spender) public view returns (uint256) {
        return allowance[owner][spender];
    }
}
