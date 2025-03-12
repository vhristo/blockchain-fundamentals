const { task } = require("hardhat/config");

task("deploy", "Deploy the contract")
    .setAction(async (taskArgs,hre) => {

        if(!taskArgs.unlockTime) {
            throw new Error("Please provide unlockTime");
        }

        const ContractFactory = await hrer.ethers.getContractFactory("Lock");
        const contract = await ContractFactory.deploy(taskArgs.unlockTime);
        await contract.deployed();

        console.log("Contract deployed to:", contract.address);

        const unlockTimeSet = await contract.unlockTime();

        if (unlockTimeSet.toString() !== taskArgs.unlockTime) {
            throw new Error("Unlock time not set correctly");
        }
        
    }).addParam("unlockTime","The time when the contract will unlock")
    .addParam("owner", "The owner of the contract");