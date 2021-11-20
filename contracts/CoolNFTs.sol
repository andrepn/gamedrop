pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: Unlicense

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CoolNFTs is ERC721 {

    event NFT_Minted(uint token_id, address receiver, uint total_minted_tokens);
    
    uint total_minted_tokens = 0;
    uint token_id = 0;

    constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        
        for (uint x = 0; x < 10; x++) {
            // mint 9 NFTs for main account
            _mint(msg.sender, token_id);
            token_id += 1;
            total_minted_tokens += 1;
            x += 1;
        }
    }

    function mintNft(address receiver) external returns (uint256) {
        require(total_minted_tokens < 10000);

        _mint(receiver, token_id);

        total_minted_tokens += 1;

        emit NFT_Minted(token_id, msg.sender, total_minted_tokens);

        token_id += 1;
    }
}