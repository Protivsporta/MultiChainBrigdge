import { ethers } from "hardhat";

async function main() {
  const [signer] = await ethers.getSigners();
  const Token = await ethers.getContractFactory("TokenERC20", signer);
  const token = await BSCToken.deploy("Token", "TKN", 1000000000);
  await token.deployed();

  console.log("ERC20 token contract deployed to:", token.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});