const ethers = require("ethers");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying with account:", deployer.address);
  
    const RaffleHouse = await ethers.getContractFactory("RaffleHouse");
    const raffleHouse = await RaffleHouse.deploy();
    await raffleHouse.deployed();
  
    console.log("RaffleHouse deployed at:", raffleHouse.address);
  }
  
  main().catch((error) => {
    console.error(error);
    process.exit(1);
  });