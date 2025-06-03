const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ArbitrageFlashLoan with MockLendingPool on BNB Testnet Fork", function () {
  let arbitrage, mockLendingPool, factory, tokenA, tokenB, tokenC, owner, addr1;
  let pairAB, pairBC, pairCA;
  const PANCAKESWAP_ROUTER = "0xD99D1c33F9fC3444f8101754aBC46c52416550D1"; // BNB Testnet PancakeSwap V2

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();

    // Deploy mock ERC20 tokens
    const MockERC20 = await ethers.getContractFactory("MockERC20");
    tokenA = await MockERC20.deploy("Token A", "TKA", ethers.parseEther("1000000"));
    tokenB = await MockERC20.deploy("Token B", "TKB", ethers.parseEther("1000000"));
    tokenC = await MockERC20.deploy("Token C", "TKC", ethers.parseEther("1000000"));

    // Deploy mock Uniswap V2 factory
    const MockUniswapV2Factory = await ethers.getContractFactory("MockUniswapV2Factory");
    factory = await MockUniswapV2Factory.deploy();

    // Create pairs
    await factory.createPair(tokenA, tokenB);
    await factory.createPair(tokenB, tokenC);
    await factory.createPair(tokenC, tokenA);

    // Get pair addresses
    pairAB = await factory.getPair(tokenA, tokenB);
    pairBC = await factory.getPair(tokenB, tokenC);
    pairCA = await factory.getPair(tokenC, tokenA);

    // Add liquidity to pairs
    const liquidityAmount = ethers.parseEther("10000");
    const liquidityAmount2 = ethers.parseEther("11000");
    await tokenA.approve(pairAB, liquidityAmount);
    await tokenB.approve(pairAB, liquidityAmount2);
    await tokenB.approve(pairBC, liquidityAmount);
    await tokenC.approve(pairBC, liquidityAmount2);
    await tokenC.approve(pairCA, liquidityAmount);
    await tokenA.approve(pairCA, liquidityAmount2);

    const pairABContract = await ethers.getContractAt("MockUniswapV2Pair", pairAB);
    const pairBCContract = await ethers.getContractAt("MockUniswapV2Pair", pairBC);
    const pairCAContract = await ethers.getContractAt("MockUniswapV2Pair", pairCA);

    await pairABContract.addLiquidity(liquidityAmount, liquidityAmount2);
    await pairBCContract.addLiquidity(liquidityAmount, liquidityAmount2);
    await pairCAContract.addLiquidity(liquidityAmount, liquidityAmount2);

    // Deploy MockPancakeSwapRouter
    const MockPancakeSwapRouter = await ethers.getContractFactory("MockPancakeSwapRouter");
    const mockPancakeSwapRouter = await MockPancakeSwapRouter.deploy();

    // Deploy MockLendingPool
    const MockLendingPool = await ethers.getContractFactory("MockLendingPool");
    mockLendingPool = await MockLendingPool.deploy();

    // Deploy ArbitrageFlashLoan with MockLendingPool
    const ArbitrageFlashLoan = await ethers.getContractFactory("ArbitrageFlashLoan");
    arbitrage = await ArbitrageFlashLoan.deploy(mockLendingPool, mockPancakeSwapRouter);

    // Fund MockLendingPool with TokenA
    const loanAmount = ethers.parseEther("100");
    await tokenA.approve(mockLendingPool, loanAmount);
    await mockLendingPool.fundPool(tokenA, loanAmount);

    // Approve tokens for PancakeSwap router
    await tokenA.approve(PANCAKESWAP_ROUTER, ethers.parseEther("10000"));
    await tokenB.approve(PANCAKESWAP_ROUTER, ethers.parseEther("10000"));
    await tokenC.approve(PANCAKESWAP_ROUTER, ethers.parseEther("10000"));
  });

  it("Should deploy contracts correctly", async function () {
    expect(arbitrage.address).to.not.equal(0);
    expect(mockLendingPool.address).to.not.equal(0);
    expect(tokenA.address).to.not.equal(0);
    expect(tokenB.address).to.not.equal(0);
    expect(tokenC.address).to.not.equal(0);
    expect(pairAB).to.not.equal(0);
    expect(pairBC).to.not.equal(0);
    expect(pairCA).to.not.equal(0);
  });

  it("Should only allow owner to initiate arbitrage", async function () {
    await expect(
      arbitrage.connect(addr1).initiateArbitrage(
        [tokenA, tokenB, tokenC],
        ethers.parseEther("100"),
        [pairAB, pairBC, pairCA],
        [false, false, false]
      )
    ).to.be.revertedWith("Only owner can call this function");
  });

  it("Should execute flash loan and arbitrage successfully", async function () {
    const loanAmount = ethers.parseEther("100");
    const initialOwnerBalance = await tokenA.balanceOf(owner.address);

    await expect(
      arbitrage.initiateArbitrage(
        [tokenA, tokenB, tokenC],
        loanAmount,
        [pairAB, pairBC, pairCA],
        [false, false, false] // Use PancakeSwap router
      )
    ).to.emit(mockLendingPool, "FlashLoan");

    const poolBalance = await tokenA.balanceOf(mockLendingPool.address);
    expect(poolBalance).to.be.at.least(loanAmount);

    const finalOwnerBalance = await tokenA.balanceOf(owner.address);
    expect(finalOwnerBalance).to.be.gt(initialOwnerBalance);
  });
});