// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

error NoMoreTickets();

contract TicketNFT is ERC721, Ownable {
    uint256 private _nextTokenId;

    uint256 public immutable date; // date is timestamp
    address public immutable organizer;
    uint256 ticketAvailabliity;

    constructor(
        address initialOwner,
        string memory raffleName,
        string memory raffleSymbol,
        uint256 date_, //timestamp
        uint256 ticketAvailability_,
        address organizer_
    ) ERC721(raffleName, raffleSymbol) Ownable(initialOwner) {
        date = date_;
        ticketAvailabliity = ticketAvailability_;
        organizer = organizer_;
    }

    function safeMint(address to) public onlyOwner {
        if (_nextTokenId == ticketAvailabliity) {
            revert NoMoreTickets();
        }
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }
}