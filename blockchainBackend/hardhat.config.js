require("@nomiclabs/hardhat-waffle");
require("dotenv").config({})
module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: process.env.ALCHEMY_URL_RINKEBY,
      accounts: [process.env.ACCOUNT]
    },
    kovan: {
      url: process.env.ALCHEMY_URL_KOVAN,
      accounts: [process.env.ACCOUNT]
    }
  }
};
