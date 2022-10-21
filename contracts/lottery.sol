// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Lottery {
    address public manager;
    address payable[] private participants;

    constructor() {
        manager = msg.sender;
    }

    modifier isManager() {
        require(msg.sender == manager, "You must be the manager");
        _;
    }

    function CheckBalance() external view isManager returns (uint256) {
        return address(this).balance;
    }

    function participantsCount() public view isManager returns (uint256) {
        return participants.length;
    }

    function generateRandomInteger() private view returns (uint256) {
        bytes memory encoded = abi.encodePacked(
            block.timestamp,
            participantsCount()
        );
        return uint256(keccak256(encoded));
    }

    function SelectWinner() external isManager {
        require(participantsCount() > 3, "Participants Count must be > 3");

        uint256 randomInt = generateRandomInteger();
        randomInt = randomInt % participantsCount();

        // Transferring all funds to winner
        participants[randomInt].transfer(address(this).balance);

        // Reset contract
        delete participants;
    }

    receive() external payable {
        require(msg.value == 2 ether, "You must send exactly 2 ether");
        participants.push(payable(msg.sender));
    }
}
