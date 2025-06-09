const hre = require("hardhat");
const { ChainId } = require('@pancakeswap/sdk')
const { SMART_ROUTER_ADDRESSES } = require('@pancakeswap/smart-router')

const chainId = ChainId.BSC
const smartRouterAddress = SMART_ROUTER_ADDRESSES[chainId];

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  // // Optional: Deploy mock lending pool if needed
  // const MockLendingPool = await hre.ethers.getContractFactory("MockLendingPool");
  // const mockLendingPool = await MockLendingPool.deploy();
  // await mockLendingPool.deployed();
  // console.log("MockLendingPool deployed to:", mockLendingPool.address);

  // const ArbitrageFlashLoan = await hre.ethers.getContractFactory("ArbitrageFlashLoan");
  // const arbitrage = await ArbitrageFlashLoan.deploy();
  
  // await arbitrage.deployed();
  // console.log("ArbitrageFlashLoan deployed to:", arbitrage.address);

  const FlashLoadSmartRouter = await hre.ethers.getContractFactory("FlashLoadSmartRouter");
  const router = await FlashLoadSmartRouter.deploy(smartRouterAddress)
  console.log("FlashLoadSmartRouter deployed to:", router.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
