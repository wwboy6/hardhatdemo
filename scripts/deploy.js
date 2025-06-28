const hre = require("hardhat");
// const { ChainId } = require('@pancakeswap/sdk')
const { bscTokens } = require('@pancakeswap/tokens')
const { SMART_ROUTER_ADDRESSES } = require('@pancakeswap/smart-router')
const { CommandType, pancakeswapUniversalRouter, uniswapUniversalRouter } = require('../include/universal-router')
const { loanPoolProvider } = require('../include/aave')

// const chainId = ChainId.BSC

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  const balance0 = await hre.ethers.provider.getBalance(deployer.address)
  console.log(`balance0 ${balance0}`)

  // const SimpleTest = await hre.ethers.getContractFactory("SimpleTest");
  // const test = await SimpleTest.deploy()
  // await test.waitForDeployment();
  // console.log("SimpleTest deployed to:", await test.getAddress());

  // const FlashLoadSmartRouter = await hre.ethers.getContractFactory("FlashLoadSmartRouter");
  // const router = await FlashLoadSmartRouter.deploy(pancakeswapUniversalRouter)
  // await router.waitForDeployment();
  // console.log("FlashLoadSmartRouter deployed to:", await router.getAddress());

  // const PancakeswapArbitrage = await hre.ethers.getContractFactory("PancakeswapArbitrage");
  // const router = await PancakeswapArbitrage.deploy(pancakeswapUniversalRouter)
  // await router.waitForDeployment();
  // console.log("PancakeswapArbitrage deployed to:", await router.getAddress());

  const UniversalArbitrage = await hre.ethers.getContractFactory("UniversalArbitrage");
  const router = await UniversalArbitrage.deploy(
    pancakeswapUniversalRouter,
    uniswapUniversalRouter,
    loanPoolProvider,
    bscTokens.wbnb.address,
  )
  await router.waitForDeployment();
  console.log("UniversalArbitrage deployed to:", await router.getAddress());

  const balance1 = await hre.ethers.provider.getBalance(deployer.address)
  const currencyInUsd = 647
  const currencyInHkd = currencyInUsd * 7.8
  const balanceDiff = Number(hre.ethers.formatEther(balance0 - balance1))
  console.log('balance used', balanceDiff, balanceDiff*currencyInHkd)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
