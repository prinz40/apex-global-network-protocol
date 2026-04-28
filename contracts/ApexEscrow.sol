// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title Apex Global Network - Escrow
 * @dev Secure trust engine for handling transactions
 */
contract ApexEscrow {
    address public arbiter;
    address payable public beneficiary;
    address public depositor;

    event FundsReleased(uint256 amount);

    constructor(address _arbiter, address payable _beneficiary) payable {
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;
    }

    function release() public {
        require(msg.sender == arbiter, "Only arbiter can release funds");
        uint256 balance = address(this).balance;
        payable(beneficiary).transfer(balance);
        emit FundsReleased(balance);
    }
}
