// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract PancakeswapArbitrage {
    address public smartRouterAddress;

    constructor(address _sra) {
        require(_sra != address(0), "Invalid router address");
        smartRouterAddress = _sra;
    }

    // TODO: loanC loanType loadAmount
    // assume all involved currencies are not native
    // TODO: use array?
    function attack(address inCoinAddress, uint approvingSwapIn, bytes calldata callData0, address midCoinAddress, bytes calldata callData1) public {
        // TODO:
        // assert(inCoinAddress)
        // permit coin
        IERC20(inCoinAddress).transferFrom(msg.sender, smartRouterAddress, approvingSwapIn);
        // Perform low-level call with value and calldata
        // TODO: without returnData?
        (bool success, bytes memory returnData) = smartRouterAddress.call(callData0);
        if (!success) revert("first trade failed");
        uint midBalance = IERC20(midCoinAddress).balanceOf(address(this));
        // get and transfer balance
        IERC20(midCoinAddress).transfer(smartRouterAddress, midBalance);
        // Perform low-level call with value and calldata
        // TODO: get amountReceived from returnData?
        (success, returnData) = smartRouterAddress.call(callData1);
        if (!success) revert("second trade failed");
        // get balance of inCoin
        uint finalBalance = IERC20(inCoinAddress).balanceOf(address(this));
        if (finalBalance < approvingSwapIn) revert("not profitible");
        IERC20(inCoinAddress).transfer(msg.sender, finalBalance);
    }
}
