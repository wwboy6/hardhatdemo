# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```

# Deployed contract

ArbitrageFlashLoan
2025/06/18 11:57 0xca0cc700F5DbFF1662d03a64361600Caa3DA8fd7

# Pitfall

## Anvil

- Before calling any contract function, better deploy the contract to be tested first, or it may raise error about failing to get historical block
- For some case WBNB.withdraw is not working when calling it in solidity
- For some case Universal Router V4 is not working
