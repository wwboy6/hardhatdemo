// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// interface IERC20Wrapped is IERC20 {
//     function deposit() external payable;
//     function withdraw(uint256 wad) external;
// }
interface IERC20Wrapped {
    function deposit() external payable;
    function withdraw(uint256 wad) external;
}
