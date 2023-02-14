// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

contract RToken is ERC20, ERC20Permit {
    constructor() ERC20("randomERC", "rERC") ERC20Permit("randomERC") {}

    //Anyone calling this function will receive 10000000000000000000 rERC
    function mint() external {
        _mint(msg.sender, 10 * 10**18);
    }
}
