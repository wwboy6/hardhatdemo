// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.28;

/// @title Commands
/// @notice Command Flags used to decode commands
library Commands {
  // Masks to extract certain bits of commands
  bytes1 internal constant FLAG_ALLOW_REVERT = 0x80;
  bytes1 internal constant COMMAND_TYPE_MASK = 0x3f;

  // Command Types. Maximum supported command at this moment is 0x3f.
  // The commands are executed in nested if blocks to minimise gas consumption

  // Command Types where value<=0x07, executed in the first nested-if block
  bytes1 constant V3_SWAP_EXACT_IN = 0x00;
  bytes1 constant V3_SWAP_EXACT_OUT = 0x01;
  bytes1 constant PERMIT2_TRANSFER_FROM = 0x02;
  bytes1 constant PERMIT2_PERMIT_BATCH = 0x03;
  bytes1 constant SWEEP = 0x04;
  bytes1 constant TRANSFER = 0x05;
  bytes1 constant PAY_PORTION = 0x06;
  // COMMAND_PLACEHOLDER = 0x07;

  // Command Types where 0x08<=value<=0x0f, executed in the second nested-if block
  bytes1 constant V2_SWAP_EXACT_IN = 0x08;
  bytes1 constant V2_SWAP_EXACT_OUT = 0x09;
  bytes1 constant PERMIT2_PERMIT = 0x0a;
  bytes1 constant WRAP_ETH = 0x0b;
  bytes1 constant UNWRAP_WETH = 0x0c;
  bytes1 constant PERMIT2_TRANSFER_FROM_BATCH = 0x0d;
  bytes1 constant BALANCE_CHECK_ERC20 = 0x0e;
  // COMMAND_PLACEHOLDER = 0x0f;

  // Command Types where 0x10<=value<=0x20, executed in the third nested-if block
  bytes1 constant V4_SWAP = 0x10;
  bytes1 constant V3_POSITION_MANAGER_PERMIT = 0x11;
  bytes1 constant V3_POSITION_MANAGER_CALL = 0x12;
  bytes1 constant V4_INITIALIZE_POOL = 0x13;
  bytes1 constant V4_POSITION_MANAGER_CALL = 0x14;
  // COMMAND_PLACEHOLDER = 0x15 -> 0x20

  // Command Types where 0x21<=value<=0x3f
  bytes1 constant EXECUTE_SUB_PLAN = 0x21;
  // COMMAND_PLACEHOLDER for 0x22 to 0x3f
}
