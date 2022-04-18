import { ethers } from "hardhat";

async function main() {
  const [signer] = await ethers.getSigners();

  const backendAddress = "0x7Ac51e9D2C3daC0f401dd546F27b36d49cE2FB7c";

  const Bridge = await ethers.getContractFactory("Bridge", signer);
  const bridge = await BridgeBSC.deploy("0x0107A4034DC1fCE4Adaff24Cd57A97bB79B64991", backendAddress); 
  await bridge.deployed();

  console.log("Bridge contract deployed to:", bridge.address);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});