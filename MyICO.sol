// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "./MyToken.sol";

contract MyICO is MyToken {
    address public owner;
    uint public phase = 1;
    uint public preSaleQty = 30000000*10**9;
    uint public seedSaleQty = 50000000*10**9;
    uint public finalSaleQty = totalSupply() - (preSaleQty + seedSaleQty);
    uint public tokensMinted = 0;
    uint public tokensLeft = totalSupply();
    uint private DENOMINATOR = 10**5;

    modifier validatePurchase () {
        require(msg.value >= DENOMINATOR,"Amount of wei entered should be greater than or equals to 10**5");
        _;
    }

    constructor () {
        owner = msg.sender;
    }

    function fundRaised()public view returns(uint) {
        return address(this).balance;
    }

    function getRate() private view returns(uint) {
        if(phase == 1) {
            return 28;
        }else if(phase == 2) {
            return 14;
        }else {
            return 7;
        }
    }

    function buyTokens(address receiver) public payable validatePurchase {
        uint weiAmount = msg.value;
        uint tokenAmount = weiAmount * getRate() / DENOMINATOR;

        mint(receiver, tokenAmount);
    }

    function mint(address receiver, uint tokenAmount) private {
        uint tokens = tokensMinted + tokenAmount;
        require(phase == 1 && tokens <= preSaleQty || phase == 2 && tokens <= preSaleQty + seedSaleQty || phase == 3 && tokens <= totalSupply());
        
        _mint(receiver, tokenAmount);

        tokensMinted += tokenAmount;
        tokensLeft -= tokenAmount;

        if(phase == 1 && preSaleQty - tokensMinted == 0){
            phase++;
        }else if(phase == 2 && (preSaleQty + seedSaleQty) - tokensMinted == 0){
            phase++;
        }
    }
}