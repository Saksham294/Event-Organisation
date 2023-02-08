pragma solidity >=0.5.0 <0.9.0;

contract EventContract {
    struct Event{
        address organiser;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemaining;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name,uint date,uint price,uint ticketCount) external{
        require(date>block.timestamp,"You can organise this event for a future date");
        require(ticketCount>0,"Insufficient tickets to organise an event");

        events[nextId]=Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
    }
    function buyTicket(uint id,uint quantity) external payable{
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has already occured");
        Event storage _event = events[id];
        require(msg.value==(_event.price*quantity),"Not enough ether");
        require(_event.ticketRemaining>=quantity,"Not enough tickets");
        _event.ticketRemaining-=quantity;
        tickets[msg.sender][id]+=quantity;
    }

     function transferTicket(uint id,uint quantity,address to) external{
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has already occured");
        require(tickets[msg.sender][id]>=quantity,"You don't have tickets to spare");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
 }

}


