CommandType = {
  V3_SWAP_EXACT_IN: "0x00",
  V3_SWAP_EXACT_OUT: "0x01",
  PERMIT2_TRANSFER_FROM: "0x02",
  PERMIT2_PERMIT_BATCH: "0x03",
  SWEEP: "0x04",
  TRANSFER: "0x05",
  PAY_PORTION: "0x06",

  V2_SWAP_EXACT_IN: "0x08",
  V2_SWAP_EXACT_OUT: "0x09",
  PERMIT2_PERMIT: "0x0a",
  WRAP_ETH: "0x0b",
  UNWRAP_WETH: "0x0c",
  PERMIT2_TRANSFER_FROM_BATCH: "0x0d",
  BALANCE_CHECK_ERC20: "0x0e",

  V4_SWAP: "0x10",
  V3_POSITION_MANAGER_PERMIT: "0x11",
  V3_POSITION_MANAGER_CALL: "0x12",
  V4_INITIALIZE_POOL: "0x13",
  V4_POSITION_MANAGER_CALL: "0x14",

  EXECUTE_SUB_PLAN: "0x21",

}

// const pancakeswapUniversalRouter = "0xd9C500DfF816a1Da21A48A732d3498Bf09dc9AEB" // V4
const pancakeswapUniversalRouter = "0x1A0A18AC4BECDDbd6389559687d1A73d8927E416" // V3
const uniswapUniversalRouter = "0x1906c1d672b88cd1b9ac7593301ca990f94eae07"

module.exports = {
  CommandType,
  pancakeswapUniversalRouter,
  uniswapUniversalRouter,
}
