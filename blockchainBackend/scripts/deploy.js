 main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNft");
    const nftContract = await nftContractFactory.deploy()
    await nftContract.deployed()

    console.log("Nft Contract Address => ", nftContract.address);

    // let txn = await nftContract.makeAnEpicNft();
    // await txn.wait()
    // console.log("Minted NFT #1");

    // txn = await nftContract.makeAnEpicNft();
    // await txn.wait()
    // console.log("Minted NFT #2");

}

 runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
}

runMain()