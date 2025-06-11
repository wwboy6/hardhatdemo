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

  const FlashLoadSmartRouter = await hre.ethers.getContractFactory("FlashLoadSmartRouter");
  const router = await FlashLoadSmartRouter.deploy(smartRouterAddress)
  await router.waitForDeployment();
  console.log("FlashLoadSmartRouter deployed to:", await router.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
