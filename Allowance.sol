//SPDX-License-Identifier: MIT

pragma solidity 0.8.1;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

// Recent update of Solidity : the Integer type variables cannot overflow anymore. 
// So not using SafeMath library

contract Allowance is Ownable {
    
    event AllowanceChanged(address indexed _forWho, address indexed _byWhom, uint _oldAmount, uint _newAmount);
    
    mapping(address => uint) public allowance;
    
    function setAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] + _amount);
        allowance[_who] = _amount;
    }
    
    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount, "Violating Allowance Guidelines");
        _;    
    }
    
    function isOwner() public view returns(bool) {
        return owner() == msg.sender;
    }
    
    function reduceAllowance(address _who, uint _amount) internal ownerOrAllowed(_amount) {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] + _amount);
        allowance[_who] -= _amount;
    }
    
    
    // Overrinding Ownable library function
    // We don't want this operation.
    function renounceOwnership() public override onlyOwner {
        revert("This operation is not allowed in this contract");
    }

    
}
