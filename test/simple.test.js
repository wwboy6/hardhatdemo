const { expect } = require("chai");
const { ethers } = require("hardhat");

const { bscTokens } = require('@pancakeswap/tokens');
const ERC20 = require("@openzeppelin/contracts/build/contracts/ERC20.json");

describe("ArbitrageFlashLoan with MockLendingPool on BNB Testnet Fork", function () {
    it("read balance", async function () {
        const [addr1, addr2] = await ethers.getSigners();
        let balance = await ethers.provider.getBalance(addr1)
        console.log("addr1 eth", balance);
        balance = await ethers.provider.getBalance(addr2)
        console.log("addr2 eth", balance);
        expect(balance).greaterThan(0);
    })
    it("is able to transfer ETH", async function () {
        const [addr1, addr2] = await ethers.getSigners();
        const orignialBalance = await ethers.provider.getBalance(addr2)
        // console.log("addr2 eth", orignialBalance);
        const amountToSend = ethers.parseEther("100");
        await addr1.sendTransaction({
            to: addr2,
            value: amountToSend,
            // gasLimit: 21000,
        });
        const balance = await ethers.provider.getBalance(addr2)
        // console.log("after transfer");
        // console.log("addr1 eth", await ethers.provider.getBalance(addr1));
        // console.log("addr2 eth", balance);
        expect(balance).equals(orignialBalance + amountToSend);
    })
    it("check balance of a ERC20 token", async function () {
        const [addr1, addr2] = await ethers.getSigners();
        const tokenContract = new ethers.Contract(bscTokens.usdt.address, ERC20.abi, ethers.provider);
        const balanceRaw = await tokenContract.balanceOf(addr2.address);
        const decimal = await tokenContract.decimals();
        const balance = ethers.formatUnits(balanceRaw, decimal);
        console.log("ERC20 token for signer", balance);
        console.log("balanceRaw", balanceRaw);
    })
    it("approve ERC20 token", async function () {
        const [addr1, addr2] = await ethers.getSigners();
        let tokenContract = new ethers.Contract(bscTokens.usdt.address, ERC20.abi, ethers.provider);
        tokenContract = tokenContract.connect(addr2)
        const contractAddr = '0x13f4EA83D0bd40E75C8222255bc855a974568Dd4' // pancake swap smart router
        await tokenContract.approve(contractAddr, 10000n * 10n**18n)
        console.log("done");
    })
});
