// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    uint256 public initialSupply = 1000 * 10 ** 18; // Initial supply of 1000 tokens (18 decimals)

    // Constructor to initialize the token and mint the initial supply
    constructor() ERC20("MyToken", "MTK") {
        // Mint initial tokens to the contract itself
        _mint(address(this), initialSupply);
    }

    // Transfer tokens from the contract to any address
    function transferFromContract(address to, uint256 amount) public {
        // Ensure that the contract has enough balance
        require(balanceOf(address(this)) >= amount, "Insufficient balance in contract");

        // Transfer tokens from the contract to the given address
        _transfer(address(this), to, amount);
    }
}