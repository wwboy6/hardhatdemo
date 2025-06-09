//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockUniswapV2Router {
    bool public unprofitableTrade;
    
    constructor() {
        unprofitableTrade = false;
    }
    
    function setUnprofitableTrade(bool _unprofitable) external {
        unprofitableTrade = _unprofitable;
    }
    
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts) {
        require(path.length == 2, "Invalid path");
        require(deadline >= block.timestamp, "Deadline passed");
        
        IERC20 tokenIn = IERC20(path[0]);
        IERC20 tokenOut = IERC20(path[1]);
        
        // Simulate swap: transfer tokens to caller
        uint amountOut = unprofitableTrade ? amountIn / 2 : amountIn * 2; // Simulate profit or loss
        require(tokenIn.transferFrom(msg.sender, address(this), amountIn), "Transfer in failed");
        require(tokenOut.transfer(to, amountOut), "Transfer out failed");
        
        amounts = new uint[](2);
        amounts[0] = amountIn;
        amounts[1] = amountOut;
    }
    
    function getAmountsOut(
        uint amountIn,
        address[] calldata path
    ) external view returns (uint[] memory amounts) {
        require(path.length == 2, "Invalid path");
        
        amounts = new uint[](2);
        amounts[0] = amountIn;
        amounts[1] = unprofitableTrade ? amountIn / 2 : amountIn * 2;
    }
}