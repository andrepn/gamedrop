pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: Unlicense

/*
CONTRACT FOR GENERATING SAMPLE ERC20 FOR TESTING
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GamingTestToken is ERC20 {
    constructor (string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        _mint(msg.sender, 10000000000);
    }
}