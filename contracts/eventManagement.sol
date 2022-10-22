// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract EventManagement {
    address manager;

    constructor() {
        manager = msg.sender;
    }

    modifier isManager() {
        require(msg.sender == manager, "Only manager can access this");
        _;
    }

    struct Event {
        uint256 price;
        uint256 totalTickets;
        uint256 ticketsPurchased;
        uint256 eventDate;
        mapping(address => uint256) attendees;
    }

    mapping(string => Event) public events;

    function showEventPrice(string memory _name)
        external
        view
        returns (uint256)
    {
        return events[_name].price;
    }

    function createNewEvent(
        string memory _eventName,
        uint256 _price,
        uint256 _totalTickets,
        uint256 _eventDate
    ) external isManager {
        Event storage e = events[_eventName];
        e.price = _price;
        e.totalTickets = _totalTickets;
        e.eventDate = _eventDate;
    }

    function purchaseTickets(string memory _name, uint256 _count)
        external
        payable
    {
        require(events[_name].eventDate > 0, "Event does not exist");
        Event storage targetEvent = events[_name];

        uint256 requiredAmount = _count * targetEvent.price;
        string memory _requiredAmount = Strings.toString(requiredAmount);
        string memory ms = string.concat(
            "Please transfer the requires amount. Amount required: ",
            _requiredAmount
        );
        require(msg.value == requiredAmount * (10**18), string(ms));

        require(
            targetEvent.ticketsPurchased < targetEvent.totalTickets,
            "No tickets left"
        );

        // Register
        targetEvent.attendees[msg.sender] = _count;
        targetEvent.ticketsPurchased++;
    }

    modifier isValidTicket(string memory _eventName) {
        require(events[_eventName].eventDate > 0, "Event does not exist");

        address _adr = msg.sender;

        require(
            events[_eventName].attendees[_adr] > 0,
            "You haven't bought the ticket"
        );
        _;
    }

    function verifyTicket(string memory _eventName)
        external
        isValidTicket(_eventName)
    {}

    function cancelTicket(
        string memory _eventName,
        uint256 NumOfticketsToCancel
    ) external isValidTicket(_eventName) {
        address _adr = msg.sender;
        Event storage targetEvent = events[_eventName];
        require(
            targetEvent.attendees[_adr] >= NumOfticketsToCancel,
            "You don't have enough tickets"
        );

        targetEvent.attendees[_adr] -= NumOfticketsToCancel;
        targetEvent.ticketsPurchased -= NumOfticketsToCancel;

        // Refund 50%
        uint256 amountToRefund = ((NumOfticketsToCancel * targetEvent.price) /
            2) * (10**18);
        payable(msg.sender).transfer(amountToRefund);
    }
}
