// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.25;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Crowd is ERC20 {
    constructor() ERC20("Crowd", "CRW") {
        _mint(msg.sender, 50_000 * 10 ** decimals());
    }

    function decimals() public view override returns (uint8) {
        return 8;
    }
}