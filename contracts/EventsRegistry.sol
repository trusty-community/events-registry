// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract EventsRegistry {
    struct EventsRegistry {
        string eventId;
        string completeEventId;
        string eventUri;
        string hash;
        uint timestamp;
        address sender;
    }
    EventsRegistry[] events;

    //Variables
    address owner;
    mapping (string => uint) eventToId;
    event newEvent(string indexed hash, string eventId, string eventUri, address sender);
    string blockchainPlatform;

    function appendString(string memory _a, string memory _b, string memory _c) internal pure returns (string memory)  {
        return string(abi.encodePacked(_a, _b, _c));
    }

    //Constructor
    constructor (string memory blockchain) public{
        blockchainPlatform = blockchain;
        owner = msg.sender;
        EventsRegistry memory _events = EventsRegistry({
            eventId: "",
            completeEventId: appendString(blockchainPlatform,":",""),
            eventUri: "",
            hash: "",
            timestamp: block.timestamp,
            sender: owner
         });
        events.push(_events);
        eventToId[""] = 0;
    }

    function registerEvent (string memory eventId, string memory eventUri, string memory hashData) public {
        if(eventToId[eventId]==0){
            uint id = events.length;
            EventsRegistry memory _events = EventsRegistry({
                eventId: eventId,
                completeEventId: appendString(blockchainPlatform,":",eventId),
                eventUri: eventUri,
                hash: hashData,
                timestamp: block.timestamp,
                sender: owner
            });
            events.push(_events);
            emit newEvent(hashData,eventId,eventUri,msg.sender);
            eventToId[eventId] = id;
        } else {
            if(events[eventToId[eventId]].sender == msg.sender){
                events[eventToId[eventId]].eventUri = eventUri;
                events[eventToId[eventId]].hash = hashData;
                events[eventToId[eventId]].timestamp = block.timestamp;
                emit newEvent(hashData,eventId,eventUri,msg.sender);
            }
        }
    }

    function getEvent (string memory eventId) public view returns(string memory,string memory,string memory,string memory,uint,address){
        return (
            events[eventToId[eventId]].eventId,
            events[eventToId[eventId]].completeEventId,
            events[eventToId[eventId]].eventUri,
            events[eventToId[eventId]].hash,
            events[eventToId[eventId]].timestamp,
            events[eventToId[eventId]].sender
        );
    }
}
