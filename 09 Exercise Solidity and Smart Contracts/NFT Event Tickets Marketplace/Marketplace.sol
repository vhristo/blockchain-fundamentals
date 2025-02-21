// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Event} from "./Event.sol";

error InvalidInput(string info);
error AlreadyListed();
error MustBeOrganizer();
error WrongBuyingOption();
error ProfitDistributionFailed();

enum BuyingOption {
    FixedPrice,
    Bidding
}

struct EventData {
    uint256 ticketPrice;
    BuyingOption saleType;
    uint256 saleEnds; // timestamp
}

contract Marketplace {
    uint256 public constant MIN_SALE_PERIOD = 24 hours;
    uint256 public constant SALE_FEE = 0.1 ether;

    address public immutable feeCollector;

    mapping(address => EventData) public events;
    mapping(address => uint256) public profits;

    constructor(address feeCollector_) {
        feeCollector = feeCollector_;
    }

    function createEvent(
        string memory eventName,
        uint256 date,
        string memory location,
        uint256 ticketPrice,
        BuyingOption saleType,
        uint256 saleEnds
    ) external {
        address newEvent = address(
            new Event(address(this), eventName, date, location, msg.sender)
        );

        _listEvent(newEvent, ticketPrice, saleType, saleEnds);
    }

    function listEvent(
        address newEvent,
        uint256 ticketPrice,
        BuyingOption saleType,
        uint256 saleEnds
    ) external  {
        if (msg.sender != Event(newEvent).organizer()) {
            revert MustBeOrganizer();
        }

        _listEvent(newEvent, ticketPrice, saleType, saleEnds);
    }

    function _listEvent(
        address newEvent,
        uint256 ticketPrice,
        BuyingOption saleType,
        uint256 saleEnds
    ) internal {
        // TODO: Ensure External Event contract is compatible with IEvent
        if (saleEnds > (block.timestamp + MIN_SALE_PERIOD)) {
            revert InvalidInput("salesEnds == 0");
        }

        if (events[newEvent].ticketPrice < SALE_FEE) {
            revert InvalidInput("ticketPrice >= SALE_FEE");
        }

        if (events[newEvent].saleEnds != 0) {
            revert AlreadyListed();
        }

        events[newEvent] = EventData({
            ticketPrice: ticketPrice,
            saleType: saleType,
            saleEnds: saleEnds
        });
    }

    // TODO: CHECK FOR REENTRANCY ATTACK POSSIBILITIES
    function buyTicket(address event_) external payable {
        if (events[event_].saleType != BuyingOption.FixedPrice) {
          revert WrongBuyingOption();  
        }


        if (msg.value != events[event_].ticketPrice) {
            revert InvalidInput("wrong value");
        }

        profits[Event(event_).organizer()] = msg.value - SALE_FEE;
        profits[feeCollector] += SALE_FEE;

        Event(event_).safeMint(msg.sender);
    }

    function withdrawProfit(address to) external payable {
        uint256 profit = profits[msg.sender];
        profits[msg.sender] = 0;
        (bool success, ) = to.call{value: profit}("");

        if (!success) {
            revert ProfitDistributionFailed();
        }
    }
}
