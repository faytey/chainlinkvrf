import { ethers } from "hardhat";

async function main() {
const [owner] = await ethers.getSigners();
const RFContract = await ethers.getContractFactory("RFConsumer");
const rfcontract = await RFContract.deploy(10104);
await rfcontract.deployed();

console.log(`Contract deployed at ${rfcontract.address}`);

// const LINK = await ethers.getContractAt("LinkTokenInterface", "0x514910771AF9Ca656af840dff83E8264EcF986CA");
// const COORDINATOR ="0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D";

// console.log(`Link address is ${LINK.address}`);

// await LINK.approve(rfcontract.address, 2);
const random = await ethers.getContractAt("IrandomNumber", "0xb36d8D7293FC6677c6e2bd0B1be3aD8B32C48CF9");
console.log(await (await (await random.requestRandomWords()).value));

// console.log(`balance of contract is ${LINK.balanceOf(rfcontract.address)}`);

// console.log(`allowance of contract is ${await LINK.allowance(owner.address, rfcontract.address)}`);

// const randomNumber = await rfcontract.getRandomNumber();

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
