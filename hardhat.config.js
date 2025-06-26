require("@nomicfoundation/hardhat-toolbox");
const { PRIVATE_KEY, INFURA_KEY, ZAN_API_KEY } = require("./utils/private_key");

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
        // url: `https://56.rpc.thirdweb.com`,
        url: `https://api.zan.top/node/v1/bsc/mainnet/${ZAN_API_KEY}`,
        enabled: true
      },
      hardfork: "london", // Closest Ethereum hardfork to BSC’s recent rules
    },
    local: {
      url: 'http://127.0.0.1:8545/',
      accounts: [
        PRIVATE_KEY,
        '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80',
        '0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d',
        '0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a',
        '0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6',
        '0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a',
        '0x8b3a350cf5c34c9194ca85829a2df0ec3153be0318b5e2d3348e872092edffba',
        '0x92db14e403b83dfe3df233f83dfa3a0d7096f21ca9b0d6d6b8d88b2b4ec1564e',
      ],
      blockGasLimit: 30000000,
      timeout: 600000, // 10 minutes (600,000 ms)
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
      // url: "https://56.rpc.thirdweb.com",
      url: `https://api.zan.top/node/v1/bsc/mainnet/${ZAN_API_KEY}`,
      chainId: 56,
      accounts: [
        // FIXME: another account to test transfer
        PRIVATE_KEY,
      ],
    },
  },
  mocha: {
    timeout: 300000
  },
};
