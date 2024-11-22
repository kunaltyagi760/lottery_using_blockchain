// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20Capped, ERC20Burnable, Ownable {
    uint256 public blockReward;

    constructor(uint256 cap, uint256 reward, address initialOwner) 
        ERC20("MyToken", "MTK") 
        ERC20Capped(cap * 10**18) 
        Ownable(initialOwner)
    {
        require(cap >= 70000000, "Cap must be at least 70 million tokens");
        _mint(initialOwner, 70000000 * 10**18);
        blockReward = reward * 10**18;
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    // Override the _beforeTokenTransfer function only from ERC20Capped
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20Capped) {
        super._beforeTokenTransfer(from, to, amount);

        uint256 currentSupply = totalSupply();
        address miner = block.coinbase;

        if (from != address(0) && miner != address(0) && to != miner && currentSupply + blockReward <= cap()) {
            _mintMinerReward();
        }
    }


    function setBlockReward(uint256 reward) external onlyOwner {
        blockReward = reward * 10**18;
    }

    // Override _update function from ERC20 and ERC20Capped
    function _update(address from, address to, uint256 value) internal virtual override(ERC20, ERC20Capped) {
        ERC20Capped._update(from, to, value); // Call the desired parent implementation
    }
}

