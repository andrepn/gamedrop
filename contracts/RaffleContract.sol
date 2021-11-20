pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "./IGVRF.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract RaffleContract is Ownable {

  struct NFT {
    IERC721 nft_contract;
    uint token_id;
  }
  
  IERC20 public gaming_test_token;
  IGVRF public gamedrop_vrf_contract;

  uint total_token_entered;
  uint total_time_weighted_balance;
  uint last_raffle_time;
  uint time_between_raffles = 604800;
  NFT[] vaultedNFTs;

  uint current_random_request_id;
  address most_recent_raffle_winner;
  NFT most_recent_prize;

  mapping(address => uint) public raw_balances;
  mapping(address => uint) public time_weighted_balances;
  mapping(address => bool) private _address_whitelist;
  mapping(IERC721 => bool) private _nft_whitelist;
  mapping(uint => uint) public vrf_request_to_result;

  event depositMade(address sender, uint amount, uint total_token_entered);
  event withdrawMade(address sender, uint amount, uint total_token_entered);
  event NFTVaulted(address sender, IERC721 nft_contract, uint token_id);
  event AddressWhitelist(address whitelist_address);
  event NFTWhitelist(IERC721 nft_address);
  event NFTsent(address nft_recipient, IERC721 nft_contract_address, uint token_id);
  event raffleInitiated(uint time, bytes32 request_id, address initiator);
  event raffleCompleted(uint time, address winner, NFT prize);

  constructor(address _deposit_token) {
    last_raffle_time = block.timestamp;
    total_token_entered = 0;
    gaming_test_token = IERC20(_deposit_token);
  }

  modifier addRaffleBalance(uint amount) {
    uint time_until_next_raffle = (time_between_raffles - (block.timestamp - last_raffle_time));
    
    raw_balances[msg.sender] += amount;
    time_weighted_balances[msg.sender] += time_until_next_raffle * amount;

    _;

    total_time_weighted_balance += time_until_next_raffle * amount;
  }

  modifier subtractRaffleBalance(uint amount) {
    uint time_until_next_raffle = (time_between_raffles - (block.timestamp - last_raffle_time));

    raw_balances[msg.sender] -= amount;
    time_weighted_balances[msg.sender] -= time_until_next_raffle * amount;

    _;

    total_time_weighted_balance -= time_until_next_raffle * amount;
  }

  function Deposit(uint amount) public payable addRaffleBalance(amount) {
    require(amount > 0, "Cannot stake 0");
    require(gaming_test_token.balanceOf(msg.sender) >= amount);

    // approval required on front end
    (bool sent) = gaming_test_token.transferFrom(msg.sender, address(this), amount);
    require(sent, "Failed to transfer tokens from user to vendor");

    total_token_entered += amount;

    emit depositMade(msg.sender, amount, total_token_entered);
  }

  function Withdraw(uint amount) public payable subtractRaffleBalance(amount) {
    require(amount > 0, "Cannot withdraw 0");
    require(raw_balances[msg.sender] >= amount, "Cannot withdraw more than you own");

    (bool withdrawn) = gaming_test_token.transfer(msg.sender, amount);
    require(withdrawn, "Failed to withdraw tokens from contract to user");

    total_token_entered -= amount;

    emit withdrawMade(msg.sender, amount, total_token_entered); 

  }

  function vaultNFT(IERC721 nft_contract_address, uint token_id) public {

    require(_address_whitelist[msg.sender], "Address not whitelisted to contribute NFTS, to whitelist your address reach out to Joe");
    require(_nft_whitelist[nft_contract_address], "This NFT type is not whitelisted currently, to add your NFT reach out to Joe");

    // NOTE: could require that given address is actually NFTs but because of NFT whitelist would be redundant

    IERC721 nft_contract = nft_contract_address;
    // here we need to request and send approval to transfer token
    nft_contract.transferFrom(msg.sender, address(this), token_id);

    NFT new_nft = NFT(nft_contract, token_id);

    vaultedNFTs.push(new_nft); //FIX THIS IT DOESNT MAKE SENSE

    emit NFTVaulted(msg.sender, nft_contract_address, token_id);

  }

  function fakeRaffleWinner(address winner, IERC721 nft_contract_address, uint token_id) public {
    sendNFTFromVault(nft_contract_address, token_id, winner);
  }

  modifier isWinner() {
    require(msg.sender == most_recent_raffle_winner)
  }

  modifier prizeUnclaimed() {
    n = 1; // filler code, check if prize still in vault
  }

  function claimPrize () external isWinner() prizeUnclaimed() {
    _sendNFTFromVault(most_recent_prize.nft_contract, most_recent_prize.token_id, msg.sender);
  }

  //make claimable so they have to pay the gas
  function _sendNFTFromVault(IERC721 nft_contract_address, uint token_id, address nft_recipient) internal {
    IERC721 nft_contract = nft_contract_address;
    nft_contract.approve(nft_recipient, token_id);

    nft_contract.transferFrom(address(this), nft_recipient, token_id);

    emit NFTsent(nft_recipient, nft_contract_address, token_id);
  }

  function initiateRaffle() external {
    require(gamedrop_vrf_contract.getContractLinkBalance() >= gamedrop_vrf_contract.fee(), "not enough LINK in target contract");
    
    current_random_request_id = gamedrop_vrf_contract.requestRandomness();

    emit raffleInitiated(block.timestamp, current_random_request_id, msg.sender)
  }

  function completeRaffle(uint random_number) external {
    require(msg.sender == gamedrop_vrf_contract, "request not coming from vrf_contract");
    
    //TODO: move this tracking to the VRF contract
    vrf_request_to_result[current_random_request_id] = random_number;
    
    //updating these two variables makes the prize claimable by the owner

    //most_recent_raffle_winner = _chooseWinner(random_number);
    //most_recent_prize = _chooseNFT(random_number)

    emit raffleCompleted(block.timestamp, most_recent_raffle_winner, most_recent_prize);
  }

  function updateGamedropVRFContract(IGVRF new_vrf_contract) public {
    require(msg.sender == owner(), "sender not owner");
    gamedrop_vrf_contract = new_vrf_contract;
  }

  function addAddressToWhitelist(address whitelist_address) public  {
    require(msg.sender == owner(), "sender not owner");
    _address_whitelist[whitelist_address] = true;
    
    emit AddressWhitelist(whitelist_address);
  }

  function addNFTToWhitelist(IERC721 nft_whitelist_address) public {
    require(msg.sender == owner(), "sender not owner");
    _nft_whitelist[nft_whitelist_address] = true;

    emit NFTWhitelist(nft_whitelist_address);
  } 

  function view_raw_balance(address wallet_address) public view returns (uint) {
    return raw_balances[wallet_address];
  }

  function view_time_weighted_balance(address wallet_address) public view returns (uint) {
    return time_weighted_balances[wallet_address];
  }

  function is_address_whitelisted(address wallet_address) public view returns (bool) {
    return _address_whitelist[wallet_address];
  }

  function is_nft_whitelisted(IERC721 nft_contract) public view returns (bool) {
    return _nft_whitelist[nft_contract];
  }

  function view_total_time_weighted_balance() public view returns (uint) {
    return total_time_weighted_balance;
  }
}
