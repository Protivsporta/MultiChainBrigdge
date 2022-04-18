import { task } from 'hardhat/config';
import '@nomiclabs/hardhat-ethers';

task("swap", "Swap tokens from one network to another")
  .addParam("to", "Address to transfer tokens")
  .addParam("amount", "Amount of tokens to transfer")
  .addParam("signature", "Signature of backend")
  .setAction(async (taskArgs, hre) => {
    const bridge = await hre.ethers.getContractAt("Bridge", process.env.BRIDGE_CONTRACT_ADDR!);
    await bridge.swap(taskArgs.to, taskArgs.amount, taskArgs.signature);
    console.log(`Tokens was swapped to ${taskArgs.to}!`);
  });