// SPDX-License-Identifier: MIT

pragma solidity ^ 0.8.4;
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract EventManagement {
    address manager;

    constructor(){
        manager = msg.sender;
    }

    modifier isManager(){
        require(msg.sender==manager,"Only manager can access this");
        _;
    }
    
    struct Event{
        uint price;
        uint totalTickets;
        uint ticketsPurchased;
        uint eventDate;
        mapping(address=>uint) attendees;
    }

    mapping(string=>Event) public events;
    
    function showEventPrice(string memory _name) view external returns(uint){
        return events[_name].price;
    }

    function createNewEvent(string memory _eventName, uint _price, uint _totalTickets, uint _eventDate) isManager external{
        Event storage e = events[_eventName];
        e.price = _price;
        e.totalTickets = _totalTickets;
        e.eventDate = _eventDate;
    }

    function purchaseTickets(string memory _name, uint _count) external payable{
        require(events[_name].eventDate > 0,"Event does not exist");
        Event storage targetEvent = events[_name];

        uint requiredAmount = _count * targetEvent.price;
        bytes memory ms = string.concat("Please transfer the requires amount. Amount required: ",bytes(Strings.toString(requiredAmount)));
        require(msg.value == requiredAmount*(10**18), string(ms));

        require(targetEvent.ticketsPurchased < targetEvent.totalTickets, "No tickets left");

        // Register
        targetEvent.attendees[msg.sender] = _count;
        targetEvent.ticketsPurchased ++;
    }
}