// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

struct Vote {
    address shareholder;
    uint256 shares;
    uint256 timestamp;
}

error InsuficientAmount();

contract Crowdfunding {
    mapping(address => uint256) public shares;
    Vote[] public votes;
    uint256 public a;
    uint256 sharePrice;
    uint256 totalShares;

    constructor(uint256 _initialSharePrice) {
        sharePrice = _initialSharePrice; //set the initial share price
    }


    function addShares() external payable {
        uint256 sharesToReceive = msg.value / sharePrice;
        totalShares += sharesToReceive;
        shares[msg.sender] += msg.value;

        if(msg.value < sharePrice) {
            revert InsuficientAmount();
        }

        if(msg.value % sharePrice > 0) {
            revert InsuficientAmount();
        }
    }

    function vote(address holder) external {
        votes.push(
            Vote({
                shareholder: holder,
                shares: shares[holder],
                timestamp: block.timestamp
            })
        );
    }
}
