// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DigitalWallet {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public pendingWithdrawals;
    address public admin;
    
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    
    constructor() {
        admin = msg.sender;
    }
    
    function deposit() public moreThanZero(msg.value) payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    
    // TODO: Implementasikan withdraw function
    function requestWithdraw(uint256 amount) onlyAddressOwnerWithEnoughBalance(amount) moreThanZero(amount) public {
        pendingWithdrawals[msg.sender] = amount;
    }

    function withdrawWithApproval(address destinationAddress) adminOnly public {
        balances[destinationAddress] -= pendingWithdrawals[destinationAddress];

        (bool sent, ) = destinationAddress.call{value: pendingWithdrawals[destinationAddress]}("");
        require(sent, "Failed to send token");
        pendingWithdrawals[destinationAddress] = 0;
        
        emit Withdrawal(msg.sender, pendingWithdrawals[destinationAddress]);
    }

    modifier moreThanZero(uint256 amount) {
        require(amount > 0, "Amount harus lebih dari 0");
        _;
    }

    // TODO: Implementasikan transfer function
    function transfer(uint256 amount, address destinationAddress) onlyAddressOwnerWithEnoughBalance(amount) moreThanZero(amount) public {
        balances[msg.sender] -= amount;
        balances[destinationAddress] += amount;
        emit Transfer(msg.sender, destinationAddress, amount);
    }

    // TODO: Tambahkan access control
    modifier adminOnly() {
        require(msg.sender == admin, "Only admin can do this");
        _;
    }

    modifier onlyAddressOwnerWithEnoughBalance(uint256 amount) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        _;
    }
}