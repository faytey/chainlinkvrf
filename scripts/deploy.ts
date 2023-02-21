import { ethers } from "hardhat";

async function main() {
const [owner] = await ethers.getSigners();
const RFContract = await ethers.getContractFactory("RFSubManager");
const rfcontract = await RFContract.deploy("0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D");
await rfcontract.deployed();

console.log(`Contract deployed at ${rfcontract.address}`);

// const LINK = await ethers.getContractAt("LinkTokenInterface","0x326C977E6efc84E512bB9C30f76E30c160eD06FB");

// const COORDINATOR = await ethers.getContractAt("VRFCoordinatorV2Interface","0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D");

// const createSubscription = await rfcontract.createNewSubscription();

// await rfcontract.addLinkToken(2);

// await rfcontract.requestRandomWords();

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
