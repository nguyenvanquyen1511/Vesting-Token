//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "./ERC20.sol";

contract Token is ERC20 {
  
    constructor(uint initialValue) ERC20("MyToken", "MTK") {
        _mint(msg.sender, initialValue);
    }
      
}

