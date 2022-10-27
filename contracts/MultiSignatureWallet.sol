// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

contract MultiSigWallet {
    uint256 constant NO_OF_APPROVAL = 2;
    mapping(address => bool) public approvers;
    uint8 approversCount;
    mapping(address => transfer) public transfers;

    constructor() {
        approvers[msg.sender] = true;
        approversCount++;
    }

    struct transfer {
        uint256 amount;
        mapping(address => bool) approvals;
        uint8 approvalsCount;
        bool status;
    }

    modifier isApprover() {
        require(approvers[msg.sender], "You must be a approver");
        _;
    }

    function addApprover(address _approverAddress) external isApprover {
        approvers[_approverAddress] = true;
        approversCount++;
    }

    function removeApprover(address _approverAddress) external isApprover {
        delete approvers[_approverAddress];
        approversCount--;
    }

    function createTransfer(address _toAddress, uint256 amount) external {
        transfer storage _transfer = transfers[_toAddress];
        _transfer.amount = amount;
    }

    function processTransfer(address _toAddress) internal {
        uint256 amount = transfers[_toAddress].amount;
        payable(_toAddress).transfer(amount);
        transfers[_toAddress].status = true;
    }

    function approveTransfer(address _toAddress) external isApprover {
        require(
            transfers[_toAddress].amount > 0,
            "This transfer does not exist"
        );
        transfers[_toAddress].approvals[msg.sender] = true;
        transfers[_toAddress].approvalsCount++;

        if (transfers[_toAddress].approvalsCount == NO_OF_APPROVAL) {
            processTransfer(_toAddress);
        }
    }

    receive() external payable {}
}
