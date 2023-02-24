// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IrandomNumber {
    function requestRandomWords() external returns (uint256 requestId);
}
