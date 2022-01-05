// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import {Base64} from "./libraries/Base64.sol";

contract MyEpicNft is ERC721URIStorage {
    using Counters for Counters.Counter;
    string internal svgPartOne =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string internal svgPartTwo =
        "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
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
    Counters.Counter private _tokenIds;

    constructor() payable ERC721("IronicNft", "IRONIC") {
        console.log("Wohoo, Nfts");
    }

    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        uint256 index = rand % firstWords.length;
        return firstWords[index];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        uint256 index = rand % secondWords.length;
        return secondWords[index];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        uint256 index = rand % thirdWords.length;
        return thirdWords[index];
    }

    function pickRandomColor(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        uint256 index = rand % colors.length;
        return colors[index];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNft() public {
        require((totalNftsMinted + 1) <= 50, "All 50 Nfts have been minted!");
        uint256 newItemId = _tokenIds.current();
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory randomColor = pickRandomColor(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory finalSvg = string(
            abi.encodePacked(
                svgPartOne,
                randomColor,
                svgPartTwo,
                combinedWord,
                "</text></svg>"
            )
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
