//SPDX-License-Identifier MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoadSmartRouter {
    address public smartRouterAddress;

    uint256 private constant MAX_INT =
        115792089237316195423570985008687907853269984665640564039457584007913129639935;

    constructor(address _sra) {
        smartRouterAddress = _sra;
    }

    // TODO: loanC loanType loadAmount
    // TODO: assume all involved currencies are not native
    function trade(address inCoinAddress, uint approvingSwapIn, bytes calldata callData0, address minCoinAddress, bytes calldata callData1) public payable {
        // TODO:
        // assert(inCoinAddress)
        // permit coin
        IERC20(inCoinAddress).transferFrom(msg.sender, address(this), approvingSwapIn);
        // IERC20(inCoinAddress).approve(smartRouterAddress, approvingSwapIn);
        IERC20(inCoinAddress).approve(smartRouterAddress, MAX_INT);
        // Perform low-level call with value and calldata
        // TODO: without returnData?
        (bool success, bytes memory returnData) = smartRouterAddress.call(callData0);
        if (!success) revert("first trade failed");
        // get and approve balance
        // uint memory minBalance = minCoin.balanceOf(address(this));
        IERC20(minCoinAddress).approve(smartRouterAddress, MAX_INT);
        // Perform low-level call with value and calldata
        // TODO: get amountReceived from returnData?
        (success, returnData) = smartRouterAddress.call(callData1);
        if (!success) revert("second trade failed");
        // get balance of inCoin
        uint finalBalance = IERC20(inCoinAddress).balanceOf(address(this));
        IERC20(inCoinAddress).transfer(msg.sender, finalBalance);
    }
}
