// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract IPFSNft is ERC721Enumerable, Ownable {
    using Strings for uint256;

    string _baseTokenURI;

    uint256 public tokenIds;
    uint256 public price = 0.1 ether;

    uint256 public maxTokenIds = 10;
    bool public _paused;

    modifier onlyWhenNotPaused() {
        require(!_paused, "Contract is Paused");
        _;
    }

    constructor(string memory baseURI) ERC721("LW3Punks", "LW3P") {
        _baseTokenURI = baseURI;
    }

    function mint() public payable onlyWhenNotPaused {
        require(tokenIds < maxTokenIds, "Exceed maximum LW3Punks supply");
        require(msg.value > price, "Price Not Met");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    function _baseURI() public view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // function tokenExists(uint256 temptokenId) public view returns (bool) {
    //     try ownerOf(temptokenId) returns (address) {
    //         return true;
    //     } catch {
    //         return false;
    //     }
    // }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(
            tokenExists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory baseURI = _baseURI();

        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
                : "";
    }

    function withdrow() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call({value: amount})("");
        require(sent, "Failed to withdraw");
    }

    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
