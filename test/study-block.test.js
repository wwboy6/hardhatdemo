const { expect } = require('chai')
const { ethers } = require('hardhat')
const { bscTokens } = require('@pancakeswap/tokens')
const { CommandType } = require('../include/universal-router')

const { abi: arbitrageContractAddressAbi } = require('../artifacts/contracts/UniversalArbitrage.sol/UniversalArbitrage.json')

const SwapProviderIndexPancakeSwap = 0
const SwapProviderIndexUniSwap = 1

const route = [
  {
    swapProviderIndex: SwapProviderIndexPancakeSwap,
    command: CommandType.V3_SWAP_EXACT_IN,
    path: ethers.solidityPacked(
      ['address', 'uint24', 'address', 'uint24', 'address'],
      [bscTokens.wbnb.address, 100, bscTokens.usdt.address, 500, bscTokens.wbnb.address],
    ),
  }
]

const arbitrageContractAddress = '0x9123D8bC7e6a3a62c1D02D60e79661C5c73c4089'
// const arbitrageContractAddress = '0x546760b7013c1D8B41dD0cD3210f564aFB6Fb388'
const arbitrage = new ethers.Contract(arbitrageContractAddress, arbitrageContractAddressAbi, ethers.provider)


describe('Study specific block', function () {
  it('simulates attack', async function () {
    const [owner] = await ethers.getSigners();
    const balance = await ethers.provider.getBalance(owner)
    console.log('balance', ethers.formatEther(balance))
    // const profitMin = ethers.parseUnits('200000', 'gwei')
    const profitMin = 0
    const result = await arbitrage.connect(owner).attack.staticCall(
      bscTokens.wbnb.address,
      ethers.parseEther('5'),
      route,
      profitMin,
      // {
      //   value: ethers.parseEther('0.001')
      // }
    )
    console.log(ethers.formatUnits(result, 'gwei'))
    // expect(result.toString()).to.be.bignumber.greaterThan(0)
  })
})
