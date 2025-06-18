require("@nomicfoundation/hardhat-toolbox");
const { PRIVATE_KEY, INFURA_KEY } = require("./utils/private_key");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  // compilers: [
  //   {
  //     version: "0.5.5",
  //   },
  //   {
  //     version: "0.6.6",
  //   },
  // ],
  networks: {
    hardhat: {
      forking: {
        // url: `https://bsc-mainnet.infura.io/v3/${INFURA_KEY}`,
        url: `https://56.rpc.thirdweb.com`,
        enabled: true
      },
      hardfork: "london", // Closest Ethereum hardfork to BSC’s recent rules
    },
    local: {
      url: 'http://127.0.0.1:8545/',
      accounts: [
        PRIVATE_KEY,
        '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80',
      ]
    },
    testnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      chainId: 97,
      accounts: [
        // FIXME: another account to test transfer
        PRIVATE_KEY,
      ],
    },
    mainnet: {
      url: "https://56.rpc.thirdweb.com",
      chainId: 56,
      accounts: [
        // FIXME: another account to test transfer
        PRIVATE_KEY,
      ],
    },
  },
};
