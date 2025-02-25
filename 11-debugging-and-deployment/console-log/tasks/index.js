task("deploy", "Deploy the contract", async (_, hre) => {
    const ContractFactory = await hre.ethers.getContractFactory("Lock");
    const contract = await ContractFactory.deploy(1740513657);

    console.log("Contract deployed to:", contract.target);
});