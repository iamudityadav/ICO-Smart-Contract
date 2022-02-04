// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.5.0-rc.0/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") { }

    function decimals() public pure override returns (uint8) {
		return 9;
	}

     function totalSupply() public pure override returns (uint256) {
        return 100000000*10**9;
    }
}