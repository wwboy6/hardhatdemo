// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IAavePoolAddressesProvider {
    function getPool() external view returns (address);
}

interface IAavePool {
  function flashLoanSimple(
      address receiverAddress,
      address asset,
      uint256 amount,
      bytes calldata params,
      uint16 referralCode
  ) external;
  // function getBorrowLogic() external pure returns(address);

  // function supply(
  //   address asset,
  //   uint256 amount,
  //   address onBehalfOf,
  //   uint16 referralCode
  // ) external;

  // function withdraw(address asset, uint256 amount, address to) external returns (uint256);
}
