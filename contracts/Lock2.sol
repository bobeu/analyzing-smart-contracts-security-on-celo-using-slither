// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Lock {
    uint public unlockTime;

    mapping(address => uint256) public balances;

    event Withdrawal(uint amount, uint when);

    constructor(uint _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime;
    }

    function withdraw(uint amount) public {
        // Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
        // console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);
        uint bal = balances[msg.sender];
        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(amount > 0 && bal >= amount, "Nothing to withdraw");
        unchecked {
            balances[msg.sender] = bal - amount;
        }

        (bool sent,) = address(msg.sender).call{value: amount}("");
        require(sent);
        
        emit Withdrawal(address(this).balance, block.timestamp);

    }
}
