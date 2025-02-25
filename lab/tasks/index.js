
const { ethers } = require("ethers");

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
    const accounts = await hre.ethers.getSigners();

    for (const account of accounts) {
        console.log(account.address);
    }
});

// hardhar runtime environment
task("balance", "Prints an account's balance")
.setAction(async (_, hre) => {
    const provider = new ethers.JsonRpcProvider("http://localhost:8545");
    const res = await provider.getBalance("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266");
    //const account = await hre.ethers.getSigner(taskArgs.account);
    //const balance = await account.getBalance();
    //
    //console.log(hre.ethers.utils.formatEther(balance), "ETH");
    console.log(ethers.formatEther(res), "ETH");
}
);

task("send", "Send ETH to an account")
    .addParam("address", "the address to send ETH to")
    .addParam("amount", "the amount of ETH to send")
    .setAction(async (taskArgs, hre) => {
        const [signer] = await hre.ethers.getSigners();
        const tx = await signer.sendTransaction({
            to: taskArgs.address,
            value: ethers.parseEther(taskArgs.amount),
        });

        console.log("Tx sent:", tx.hash);
        console.log("Tx sent:", tx);

        const receipt = await tx.wait();
        console.log("Tx mined:");
        console.log(receipt);
        //const signer = await hre.ethers.getSigner();
        //const tx = await signer.sendTransaction({
        //    to: taskArgs.address,
        //    value: ethers.utils.parseEther("1.0")
        //});
        //
        //await tx.wait();
        //console.log(`Sent 1.0 ETH to ${taskArgs.address}`);
    });


task("contract", "Deploy a contract")
    .addParam("name", "the name of the contract")
    .setAction(async (taskArgs, hre) => {
        const factory = await hre.ethers.getContractFactory(taskArgs.name);
        const contract = await factory.deploy();
        await contract.deployed();

        console.log("Contract deployed to:", contract.address);
    });
