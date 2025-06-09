//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "hardhat/console.sol";

contract SimpleTest {
    function test(address to) public pure returns (address _to) {
        console.log(to);
        return to;
    }
}
