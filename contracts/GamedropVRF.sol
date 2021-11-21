// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "../interfaces/IGRC.sol";

contract GamedropVRF is VRFConsumerBase, Ownable {
    
    bytes32 internal keyHash;
    uint256 internal fee;
    
    uint256 public randomResult;
    bytes32 internal currentRequestID;
    mapping(bytes32 => uint256) public requestIdToRandomNumber;

    IERC20 public link;
    IGRC public gamedrop_raffle_contract;
    
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
        currentRequestID = requestRandomness(keyHash, fee);
        return currentRequestID;
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        requestIdToRandomNumber[requestId] = randomness;
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

    function veiwRandomResponse() external view returns (uint) {
        return requestIdToRandomNumber[currentRequestID];
    }
}