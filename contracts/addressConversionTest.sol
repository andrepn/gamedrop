pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: Unlicense

contract addressConversionTest {

    function address_to_bytes32(address a) public pure returns (bytes32) {
        return bytes32(uint256(uint160(a)));
    }

    function bytest32_to_address(bytes32 b) public pure returns (address) {
        return address((uint160(uint256(b))));
    }

}