//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./aave.sol";

import "hardhat/console.sol";

contract SimpleTest {
    IAavePoolAddressesProvider loanPoolProvider = IAavePoolAddressesProvider(0xff75B6da14FfbbfD355Daf7a2731456b3562Ba6D);

    function test(address to) external pure returns (address _to) {
        console.log(to);
        return to;
    }

    function getFlashLoan() external payable {
        address payable wbnb = payable(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
        IAavePool pool = IAavePool(loanPoolProvider.getPool());
        // 0x6807dc923806fe8fd134338eabca509979a7e0cb
        // IAavePool pool = IAavePool(0x9E255f9d061405769Abb2b583C9B2c4368b482b9);
        console.log("pool");
        console.log(address(pool));

        // address addr = pool.getBorrowLogic();
        // console.log(addr);

        // // wbnb.transfer(msg.value / 2);
        // address(wbnb).call{value: msg.value/2}("");
        // pool.supply(wbnb, msg.value / 2, address(this), 0);
        // pool.withdraw(wbnb, msg.value / 2, address(this));

        uint256 amountIn = 2 ether;
    
        IAavePool(pool).flashLoanSimple(
            address(this),
            wbnb,
            1 ether,
            abi.encode(
                amountIn
            ),
            0
        );
    }
    
    // callback from simple AAVE flash load (flashLoanSimple)
    function executeOperation(
        address tokenIn,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external returns (bool) {
        console.log("executeOperation");
        console.log(amount);
        console.log(premium);

        require(msg.sender == loanPoolProvider.getPool(), "Unauthorized");
        require(initiator == address(this), "Invalid initiator");
        
        // Decode params except swaps, which remains in calldata
        (uint256 amountIn) = abi.decode(params, (uint256));
        console.log("amountIn");
        console.log(amountIn);

        // IERC20(tokenIn).approve(address(msg.sender), amount + premium);
        return true;
    }
}
