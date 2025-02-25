// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./TicketNFT.sol";

contract RaffleHouse {
    struct Raffle {
        TicketNFT ticketNFT;
        address organizer;
        uint256 ticketPrice;
        uint256 startTime;
        uint256 endTime;
        uint256 totalTickets;
        address winner;
        bool isCompleted;
    }

    mapping(uint256 => Raffle) public raffles;
    uint256 public raffleCounter;

    event RaffleCreated(
        uint256 indexed raffleId,
        address indexed organizer,
        address ticketNFT
    );
    event TicketPurchased(
        uint256 indexed raffleId,
        address indexed buyer,
        uint256 ticketId
    );
    event WinnerChosen(
        uint256 indexed raffleId,
        address indexed winner,
        uint256 winningTicketId
    );
    event PrizeClaimed(
        uint256 indexed raffleId,
        address indexed winner,
        uint256 amount
    );

    function createRaffle(
        uint256 ticketPrice,
        uint256 startTime,
        uint256 endTime,
        string memory raffleName,
        string memory raffleSymbol
    ) external {
        require(startTime < endTime, "Invalid time range");

        TicketNFT newNFT = new TicketNFT(
            msg.sender,
            raffleName,
            raffleSymbol,
            1740486013,
            1000,
            address(this)
        );
        uint256 raffleId = raffleCounter++;

        raffles[raffleId] = Raffle({
            ticketNFT: newNFT,
            organizer: msg.sender,
            ticketPrice: ticketPrice,
            startTime: startTime,
            endTime: endTime,
            totalTickets: 0,
            winner: address(0),
            isCompleted: false
        });

        emit RaffleCreated(raffleId, msg.sender, address(newNFT));
    }

    function buyTicket(uint256 raffleId) external payable {
        Raffle storage raffle = raffles[raffleId];

        require(
            block.timestamp >= raffle.startTime &&
                block.timestamp <= raffle.endTime,
            "Raffle not active"
        );
        require(msg.value == raffle.ticketPrice, "Incorrect ETH amount");

        // Fix: Change mint() to safeMint()
        raffle.ticketNFT.safeMint(msg.sender);
        raffle.totalTickets++;

        emit TicketPurchased(raffleId, msg.sender, raffle.totalTickets - 1);
    }

    function chooseWinner(uint256 raffleId) external {
        Raffle storage raffle = raffles[raffleId];

        require(block.timestamp > raffle.endTime, "Raffle not ended");
        require(!raffle.isCompleted, "Winner already chosen");
        require(raffle.totalTickets > 0, "No tickets purchased");

        uint256 winningIndex = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.prevrandao,
                    raffle.totalTickets
                )
            )
        ) % raffle.totalTickets;
        address winner = raffle.ticketNFT.ownerOf(winningIndex);

        raffle.winner = winner;
        raffle.isCompleted = true;

        emit WinnerChosen(raffleId, winner, winningIndex);
    }

    function claimPrize(uint256 raffleId) external {
        Raffle storage raffle = raffles[raffleId];

        require(raffle.isCompleted, "Winner not chosen yet");
        require(msg.sender == raffle.winner, "Not the winner");

        uint256 prizeAmount = raffle.totalTickets * raffle.ticketPrice;
        payable(msg.sender).transfer(prizeAmount);

        emit PrizeClaimed(raffleId, msg.sender, prizeAmount);
    }
}
