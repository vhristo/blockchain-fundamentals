// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

error NoMoreTickets();

contract Event is ERC721, Ownable {
    uint256 private _nextTokenId;

    uint256 public immutable date; // date is timestamp
    address public immutable organizer;
    string public location;
    uint256 ticketAvailabliity;

    constructor(
        address minter,
        string memory eventName,
        uint256 date_,
        string memory location_,
        address organizer_
    ) ERC721(eventName, "") Ownable(minter) {
        date = date_;
        location = location_;
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
