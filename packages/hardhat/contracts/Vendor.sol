// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
    }

    // 买币函数
    function buyTokens() public payable {
        uint256 amountToBuy = msg.value * tokensPerEth;

        // 建议加上：检查售货机有没有足够的货，虽然 transfer 也会报错，但这样报错信息更友好
        uint256 vendorBalance = yourToken.balanceOf(address(this));
        require(vendorBalance >= amountToBuy, "Vendor has insufficient tokens");

        // 发送代币
        bool sent = yourToken.transfer(msg.sender, amountToBuy);
        require(sent, "Failed to transfer token to user"); // 关键修复

        emit BuyTokens(msg.sender, msg.value, amountToBuy);
    }

    // 提款函数
    function withdraw() public onlyOwner {
        (bool sent, ) = msg.sender.call{ value: address(this).balance }("");
        require(sent, "Failed to send Ether");
    }

    // 卖回币函数
    function sellTokens(uint256 amount) public {
        // check that the user has enough tokens to sell
        bool success = yourToken.transferFrom(msg.sender, address(this), amount);
        require(success, "Failed to fransfer tokens from user to vendor");

        uint256 amountOfETHToRedeem = amount / tokensPerEth;
        uint256 venderEthBalance = address(this).balance;
        require(venderEthBalance >= amountOfETHToRedeem, "Vendor has insufficient ETH");

        // send ETH to the user
        (bool sent, ) = msg.sender.call{ value: amountOfETHToRedeem }("");
        require(sent, "Failed to send Ether to user");

        emit SellTokens(msg.sender, amount, amountOfETHToRedeem);
    }
}
