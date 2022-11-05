// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract EventOrganization
{
    struct Event
    {
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint Idcount;
    function createEvent(string memory name,uint date,uint price,uint ticketCount) external
    {
        require(date>block.timestamp,"You can organize event for future Date");
        require(ticketCount>0,"you can organize event only if you create more than 0 tickets");
        events[Idcount]=Event(msg.sender,name,date,price,ticketCount,ticketCount);
          Idcount++;
    }
        function buyTicket(uint id,uint quantity) external payable
        {
           require(events[id].date!=0,"Event does not exist");
           require(events[id].date>=block.timestamp,"Event has already occured");
           
           Event storage _event=events[id];
           require(msg.value==(_event.price*quantity),"Ether is not enough");
           _event.ticketRemain-=quantity;
           tickets[msg.sender][id]+=quantity;

        }
        function transferTicket(uint id,uint quantity,address toWhom) external
        {
          require(events[id].date!=0,"Event does not exist");
           require(events[id].date>=block.timestamp,"Event has already occured");
          require(tickets[msg.sender][id]>=quantity,"you do not have enough tickets");
          tickets[msg.sender][id]-=quantity;
          tickets[toWhom][id]+=quantity;
        }
}