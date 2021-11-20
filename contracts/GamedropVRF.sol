// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "./IGRC.sol";

contract GamedropVRF is VRFConsumerBase, Ownable {
    
    bytes32 internal keyHash;
    uint256 internal fee;
    
    uint256 public randomResult;
    IERC20 public link;
    IGRC public gamedrop_raffle_contract;
    
    /**
     * Constructor inherits VRFConsumerBase
     * 
     * Network: Kovan
     * Chainlink VRF Coordinator address: 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9
     * LINK token address:                0xa36085F69e2889c224210F603D836748e7dC0088
     * Key Hash: 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4
     */
    constructor(bytes32 _keyhash, address _vrfCoordinator, address _linkToken, IERC20 _link_interface) 
        VRFConsumerBase(
            _vrfCoordinator, // VRF Coordinator
            _linkToken  // LINK Token
        ) 
    {
        keyHash = _keyhash;
        fee = 0.1 * 10 ** 18; // 0.1 LINK
        // fee = _fee;;
        link = _link_interface;
    }
    
    /** 
     * Requests randomness
     */
    function getRandomNumber() external returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
        gamedrop_raffle_contract.completeRaffle(randomResult);
    }

    function setGamedropRaffleContract(IGRC raffle_contract) external onlyOwner() {
        gamedrop_raffle_contract = raffle_contract;
    }

    function getContractLinkBalance() external view returns (uint) {
        return link.balanceOf(address(this));
    }

    function getContractBalance() external view returns (uint) {
        return address(this).balance;
    }
}