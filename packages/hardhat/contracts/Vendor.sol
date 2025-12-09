// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
    }

    // 💰 买币函数
    function buyTokens() public payable {
        uint256 amountToBuy = msg.value * tokensPerEth;

        // 建议加上：检查售货机有没有足够的货，虽然 transfer 也会报错，但这样报错信息更友好
        uint256 vendorBalance = yourToken.balanceOf(address(this));
        require(vendorBalance >= amountToBuy, "Vendor has insufficient tokens");

        // 发送代币
        bool sent = yourToken.transfer(msg.sender, amountToBuy);
        require(sent, "Failed to transfer token to user"); // 👈 关键修复

        emit BuyTokens(msg.sender, msg.value, amountToBuy);
    }

    // 🏧 提款函数 (Checkpoint 2 要求)
    function withdraw() public onlyOwner {
        (bool sent, ) = msg.sender.call{ value: address(this).balance }("");
        require(sent, "Failed to send Ether");
    }

    // ToDo: create a sellTokens(uint256 _amount) function:
    // (留给 Checkpoint 3 再写)
}
