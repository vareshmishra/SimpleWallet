//SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

import "./Allowance.sol";

contract SharedWallet is Allowance {
    
    event FundsSent(address indexed _who, uint _amount);
    event FundsReceived(address indexed _from, uint _amount);
    
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Not enough funds within the contract !");
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit FundsSent(_to, _amount);
        _to.transfer(_amount);    
    }
    
    // Fallback function to receive ether into smart contract
    receive() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }
}