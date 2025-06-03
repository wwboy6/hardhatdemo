//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockUniswapV2Pair {
    address public token0;
    address public token1;
    uint112 private reserve0;
    uint112 private reserve1;

    constructor(address _token0, address _token1) {
        token0 = _token0;
        token1 = _token1;
    }

    // Simplified liquidity addition for testing
    function addLiquidity(uint amount0, uint amount1) external {
        IERC20(token0).transferFrom(msg.sender, address(this), amount0);
        IERC20(token1).transferFrom(msg.sender, address(this), amount1);
        reserve0 = uint112(amount0);
        reserve1 = uint112(amount1);
    }

    // // Simplified swap for testing (1:1 rate for simplicity)
    // function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external {
    //     require(amount0Out > 0 || amount1Out > 0, "Insufficient output amount");
    //     if (amount0Out > 0) {
    //         IERC20(token0).transfer(to, amount0Out);
    //         uint amount1In = amount0Out; // 1:1 swap for testing
    //         IERC20(token1).transferFrom(msg.sender, address(this), amount1In);
    //         reserve0 -= uint112(amount0Out);
    //         reserve1 += uint112(amount1In);
    //     } else {
    //         IERC20(token1).transfer(to, amount1Out);
    //         uint amount0In = amount1Out; // 1:1 swap
    //         IERC20(token0).transferFrom(msg.sender, address(this), amount0In);
    //         reserve1 -= uint112(amount1Out);
    //         reserve0 += uint112(amount0In);
    //     }
    // }

    function getReserves() external view returns (uint112, uint112, uint32) {
        return (reserve0, reserve1, uint32(block.timestamp));
    }
}