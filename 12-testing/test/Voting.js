const {
    loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");

const { expect } = require("chai");

describe.only("Voting", function () {
    async function deployVotingFixture() {
        const [deployer] = await ethers.getSigners();

        const VotingFactory = await ethers.getContractFactory("VotingSystem");
        const VotingContract = await VotingFactory.deploy();

        return { VotingContract, deployer };
    }

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            const { VotingContract, deployer } = await loadFixture(deployVotingFixture);

            expect(await VotingContract.owner()).to.be.equal(deployer.address);
        });

        it("Should set proposalCount to 0", async function () {
            const { VotingContract } = await loadFixture(deployVotingFixture);

            expect(await VotingContract.proposalCount()).to.be.equal(0);
        });
    });

    describe("createProposal()", function () {
        it("Should revert when caller is not owner", async function () {
            const { VotingContract } = await loadFixture(deployVotingFixture);
            const [, user] = await ethers.getSigners();

            await expect(
                VotingContract.connect(user).createProposal("Proposal 1", 1)
            ).to.be.revertedWithCustomError(VotingContract, "NotOwner");
        });
    });
});