//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "hardhat/console.sol";

contract MockLendingPool {
    function flashLoan(
        address receiver,
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes,
        address onBehalfOf,
        bytes calldata params,
        uint16 referralCode
    ) external {
        // Transfer tokens to receiver
        for (uint i = 0; i < assets.length; i++) {
            IERC20(assets[i]).transfer(receiver, amounts[i]);
        }
        
        // Call receiver's executeOperation
        (bool success, ) = receiver.call(
            abi.encodeWithSignature(
                "executeOperation(address[],uint256[],uint256[],address,bytes)",
                assets,
                amounts,
                new uint256[](assets.length), // Zero premiums for simplicity
                msg.sender,
                params
            )
        );

        console.log("flashLoan executeOperation return");
        console.log(success);

        require(success, "Flash loan callback failed");
        
        // Verify repayment
        for (uint i = 0; i < assets.length; i++) {
            require(
                IERC20(assets[i]).balanceOf(address(this)) >= amounts[i],
                "Flash loan not repaid"
            );
        }
    }
    
    // Fund the mock pool for testing
    function fundPool(address token, uint256 amount) external {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
    }
}
