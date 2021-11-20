pragma solidity >=0.8.0 <0.9.0;

interface IGRVF {
    function getRandomNumber() external returns (bytes32 requestId);

    function getContractLinkBalance() external view returns (uint);

    function getContractBalance() external view returns (uint);
}