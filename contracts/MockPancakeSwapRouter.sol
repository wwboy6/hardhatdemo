pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockPancakeSwapRouter {
    // Mapping to simulate pair reserves for token pairs
    mapping(address => mapping(address => uint256)) public reserves;

    // Event emitted on swap
    event Swap(address indexed tokenIn, address indexed tokenOut, uint256 amountIn, uint256 amountOut, address indexed to);

    // Simplified function to set reserves for testing
    function setReserves(address tokenA, address tokenB, uint256 reserveA, uint256 reserveB) external {
        reserves[tokenA][tokenB] = reserveA;
        reserves[tokenB][tokenA] = reserveB;
    }

    // Mock swapExactTokensForTokens with simplified 1:1.1 rate for testing
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts) {
        require(path.length >= 2, "Invalid path");
        require(amountIn > 0, "Invalid amountIn");
        require(deadline >= block.timestamp, "Expired");

        amounts = new uint256[](path.length);
        amounts[0] = amountIn;

        for (uint256 i = 0; i < path.length - 1; i++) {
            address tokenIn = path[i];
            address tokenOut = path[i + 1];
            uint256 reserveIn = reserves[tokenIn][tokenOut];
            uint256 reserveOut = reserves[tokenOut][tokenIn];

            // Simplified: 1:1.1 rate (10% profit per swap)
            uint256 amountOut = (amounts[i] * 11) / 10; // 1.1x output
            require(amountOut >= amountOutMin, "Insufficient output");
            require(reserveOut >= amountOut, "Insufficient reserves");

            // Transfer tokens
            IERC20(tokenIn).transferFrom(msg.sender, address(this), amounts[i]);
            IERC20(tokenOut).transfer(to, amountOut);

            // Update reserves
            reserves[tokenIn][tokenOut] += amounts[i];
            reserves[tokenOut][tokenIn] -= amountOut;

            amounts[i + 1] = amountOut;

            emit Swap(tokenIn, tokenOut, amounts[i], amountOut, to);
        }

        return amounts;
    }

    // Mock getAmountsOut for testing
    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts) {
        require(path.length >= 2, "Invalid path");
        amounts = new uint256[](path.length);
        amounts[0] = amountIn;

        for (uint256 i = 0; i < path.length - 1; i++) {
            // Simplified: 1:1.1 rate
            amounts[i + 1] = (amounts[i] * 11) / 10;
        }

        return amounts;
    }
}