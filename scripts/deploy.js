const hre = require("hardhat");
const { ChainId } = require('@pancakeswap/sdk')
const { SMART_ROUTER_ADDRESSES } = require('@pancakeswap/smart-router')

const chainId = ChainId.BSC
const smartRouterAddress = SMART_ROUTER_ADDRESSES[chainId];

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  // const SimpleTest = await hre.ethers.getContractFactory("SimpleTest");
  // const test = await SimpleTest.deploy()
  // await test.waitForDeployment();
  // console.log("SimpleTest deployed to:", await test.getAddress());

  // const FlashLoadSmartRouter = await hre.ethers.getContractFactory("FlashLoadSmartRouter");
  // const router = await FlashLoadSmartRouter.deploy(smartRouterAddress)
  // await router.waitForDeployment();
  // console.log("FlashLoadSmartRouter deployed to:", await router.getAddress());

  const balance0 = await hre.ethers.provider.getBalance(deployer.address)
  console.log(`balance0 ${balance0}`)

  const PancakeswapArbitrage = await hre.ethers.getContractFactory("PancakeswapArbitrage");
  const router = await PancakeswapArbitrage.deploy(smartRouterAddress)
  await router.waitForDeployment();
  console.log("PancakeswapArbitrage deployed to:", await router.getAddress());

  const balance1 = await hre.ethers.provider.getBalance(deployer.address)
  const currencyInHkd = 5062
  const balanceDiff = Number(hre.ethers.formatEther(balance0 - balance1))
  console.log('balance used', balanceDiff, balanceDiff*currencyInHkd)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
