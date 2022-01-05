import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import contractAbi from "../utils/MyEpicNft.json";

const OPENSEA_LINK = "https://testnets.opensea.io/collection/gokunft-l0r59bhjtk";
const TOTAL_MINT_COUNT = 50;
const CONTRACT_ADDRESS = "0xa9DD14b61D61665123781Fe175078152d01b1511";

export default function Home() {
  const [nftsMinted, setNftsMinted] = useState(0);
  const [currentAccount, setCurrentAccount] = useState();
  const [Window, setWindow] = useState(null);
  const [isMinting, setIsMinting] = useState(false);
  const checkNetwork = async () => {
    try {
      const { ethereum } = Window;
      if (!ethereum) {
        alert("Get Metamask!");
        return;
      }
      let chainId = await ethereum.request({ method: "eth_chainId" });
      console.log("Connected to chain " + chainId);

      // String, hex code of the chainId of the Rinkebey test network
      const rinkebyChainId = "0x4";
      if (chainId !== rinkebyChainId) {
        alert("You are not connected to the Rinkeby Test Network!");
      }
    } catch (error) {
      console.log(error);
    }
  };
  const checkIfWalletConnected = async () => {
    try {
      const { ethereum } = Window;
      if (!ethereum) {
        console.log("Install Metamask!");
        return;
      }

      const accounts = await ethereum.request({ method: "eth_accounts" });
      if (accounts.length != 0) {
        setCurrentAccount(accounts[0]);
        setUpEventListener();
        console.log(accounts);
      } else {
        console.log("Not authorized to view accounts!");
      }
    } catch (error) {
      console.log(error);
    }
  };

  const connectWallet = async () => {
    try {
      const { ethereum } = Window;
      if (!ethereum) {
        alert("Install Metamask!");
        return;
      }

      const accounts = await ethereum.request({
        method: "eth_requestAccounts",
      });
      if (accounts.length != 0) {
        console.log("Connected to Metamask", accounts[0]);
        console.log(accounts);
        setCurrentAccount(accounts[0]);
        setUpEventListener();
      } else {
        console.log("Not authorized to view accounts!");
      }
    } catch (error) {
      console.log(error);
    }
  };

  const setUpEventListener = async () => {
    try {
      const { ethereum } = Window;
      if (!ethereum) {
        console.log("Ethereum Object Doesnot exists!");
        return;
      }

      const provider = new ethers.providers.Web3Provider(ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(
        CONTRACT_ADDRESS,
        contractAbi.abi,
        signer
      );

      contract.on("newEpicNftMinted", async (from, tokenId) => {
        console.log(from, tokenId.toNumber());
        alert(
          `Hey there! We've minted your NFT and sent it to your wallet. It may be blank right now. It can take a max of 10 min to show up on OpenSea. Here's the link: https://testnets.opensea.io/assets/${CONTRACT_ADDRESS}/${tokenId.toNumber()}`
        );
        await totalNftsMinted();
      });
    } catch (error) {
      console.log(error);
    }
  };

  const totalNftsMinted = async () => {
    try {
      const { ethereum } = Window;
      if (!ethereum) {
        console.log("Ethereum Object Doesnot exists!");
        return;
      }

      const provider = new ethers.providers.Web3Provider(ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(
        CONTRACT_ADDRESS,
        contractAbi.abi,
        signer
      );

      const tx = await contract.getTotalNftsMinted();

      console.log(tx);
      setNftsMinted(tx.toNumber());
    } catch (error) {
      console.log(error);
    }
  };

  const askContractToMintNft = async () => {
    try {
      const { ethereum } = Window;
      if (!ethereum) {
        alert("Install Metamask!");
        return;
      }
      setIsMinting(true);
      const provider = new ethers.providers.Web3Provider(ethereum);
      console.log(provider);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(
        CONTRACT_ADDRESS,
        contractAbi.abi,
        signer
      );

      const generateRandomNumber = await contract.getRandomNumber();
      await generateRandomNumber.wait();

      let tx;
      contract.on("RandomNumberGenerated", async (randomNum) => {
        tx = await contract.makeAnEpicNft(randomNum);
        await tx.wait();
        console.log("Waiting for Tx to be mined ...");
        console.log(
          "View your transaction at: https://rinkeby.etherscan.io/tx/" + tx.hash
        );
        setIsMinting(false);
      });
    } catch (error) {
      console.log(error);
    }
  };

  useEffect(() => {
    setWindow(window)
  }, [])

  useEffect(() => {
    if(Window !== null) {
      checkNetwork();
      checkIfWalletConnected();
      totalNftsMinted();
    }
  }, [Window]);
  return (
    <div className="h-screen bg-background space-y-10">
      <div className="space-y-4">
        <h1
          className="text-5xl text-center pt-10 font-bold bg-clip-text bg-gradient-to-r from-font2 to-font1"
          style={{
            color: "transparent",
          }}
        >
          My NFT Collection
        </h1>
        <h3
          className="text-3xl text-center font-bold"
          style={{
            color: "white",
          }}
        >
          Each unique. Each beautiful. Discover your NFT today.
        </h3>
        <h4
          className="text-2xl text-center font-bold bg-clip-text bg-gradient-to-r from-font2 to-font1"
          style={{
            color: "transparent",
          }}
        >
          {`${nftsMinted}/${TOTAL_MINT_COUNT} NFT's Minted`}
        </h4>
      </div>

      <div className="text-center mt-10">
        {currentAccount ? (
          <button
            className={`${
              isMinting ? "opacity-50 cursor-not-allowed" : "cursor-pointer"
            } animate-gradient-x px-6 py-2 text-md rounded-md font-semibold text-center bg-gradient-to-r from-font2 to-font1`}
            style={{
              color: "white",
            }}
            onClick={askContractToMintNft}
          >
            {isMinting ? "Minting ..." : `Mint NFT`}
          </button>
        ) : (
          <button
            className="animate-gradient-x px-6 py-2 text-md rounded-md font-semibold text-center bg-gradient-to-r from-font2 to-font1"
            style={{
              color: "white",
            }}
            onClick={connectWallet}
          >
            Connect To Wallet
          </button>
        )}
      </div>
      <div className="text-center">
        <a target="_blank" href={OPENSEA_LINK}>
          <button
            className="animate-gradient-x px-6 py-2 text-md rounded-md font-semibold text-center bg-font1"
            style={{
              color: "white",
            }}
          >
            🌊 View Collection on OpenSea
          </button>
        </a>
      </div>
    </div>
  );
}
