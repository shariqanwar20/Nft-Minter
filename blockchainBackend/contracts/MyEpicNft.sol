// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import {Base64} from "./libraries/Base64.sol";

contract MyEpicNft is ERC721URIStorage, VRFConsumerBase {
    using Counters for Counters.Counter;
    string internal svgPartOne =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string internal svgPartTwo =
        "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 randomValIndex;
    uint256 totalNftsMinted = 0;

    string[] firstWords = [
        "Fantastic",
        "Epic",
        "Terrible",
        "Crazy",
        "Wild",
        "Terrifying",
        "Spooky",
        "Scooby",
        "SuperCaliFajilistic",
        "Rare",
        "Legendary"
    ];
    string[] secondWords = [
        "Cupcake",
        "Pizza",
        "Milkshake",
        "Curry",
        "Chicken",
        "Salad",
        "Sandwich",
        "Fish"
    ];
    string[] thirdWords = [
        "Naruto",
        "Sasuke",
        "Suki",
        "Goku",
        "Vegeta",
        "Krilin",
        "Picolo",
        "Gohan",
        "Frieza",
        "Beerus"
    ];

    string[] colors = ["red", "#08C2A8", "black", "yellow", "blue", "green"];

    event newEpicNftMinted(address sender, uint256 tokenId);
    event RandomNumberGenerated(uint256 randomness);
    Counters.Counter private _tokenIds;

    constructor()
        payable
        ERC721("GokuNFT", "GOKU")
        VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B,
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709
        )
    {
        console.log("Wohoo, Nfts");
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10**18;
    }

    function pickRandomFirstWord() public view returns (string memory) {
        uint256 index = randomValIndex % firstWords.length;
        return firstWords[index];
    }

    function pickRandomSecondWord() public view returns (string memory) {
        uint256 index = randomValIndex % secondWords.length;
        return secondWords[index];
    }

    function pickRandomThirdWord() public view returns (string memory) {
        uint256 index = randomValIndex % thirdWords.length;
        return thirdWords[index];
    }

    function pickRandomColor() public view returns (string memory) {
        uint256 index = randomValIndex % colors.length;
        return colors[index];
    }

    function getRandomNumber() public returns (bytes32 requestId) {
        require(
            LINK.balanceOf(address(this)) > fee,
            "You dont have enough LINK"
        );
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        // console.log("RequestId => ", requestId);
        randomValIndex = randomness;
        emit RandomNumberGenerated(randomness);
    }

    function makeAnEpicNft(uint256 randomNum) public {
        require((totalNftsMinted + 1) <= 50, "All 50 Nfts have been minted!");
        uint256 newItemId = _tokenIds.current();
        randomValIndex = randomNum;
        string memory first = pickRandomFirstWord();
        string memory second = pickRandomSecondWord();
        string memory third = pickRandomThirdWord();
        string memory randomColor = pickRandomColor();
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory finalSvg = string(
            abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory tokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        console.log("\n--------------------");
        console.log(tokenUri);
        console.log("--------------------\n");
        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, tokenUri);

        _tokenIds.increment();

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
        totalNftsMinted++;
        emit newEpicNftMinted(msg.sender, newItemId);

        console.log("\n--------------------");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    tokenUri
                )
            )
        );
        console.log("--------------------\n");
    }

    function getTotalNftsMinted() public view returns (uint256) {
        return totalNftsMinted;
    }
}
