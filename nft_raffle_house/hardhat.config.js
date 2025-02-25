require("@nomicfoundation/hardhat-toolbox");
require("./tasks/index.js");
require("./scripts/deploy.js");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "localhost",
  solidity: "0.8.26",
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/30b0196eefba45adb0706ce62fd1b7a6`,
      accounts: [
        "2c230f1fe20ad38671dcb06c38783690ae0f0407353794b87deb21537fdf5888", // 0x3936EC5BB18121F34F0C70D383C512B0e1fDC4D3 public key
        "18431ed6f8e4c31985122db2f91d4c279ab6fdd76caf93bc4814ea545077a0df", // 0x96C235AAcc8EC4eB50F9804e28123a1153E40d35 public key
      ],
    },
  },
};
