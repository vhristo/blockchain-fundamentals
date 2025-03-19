// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.25;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

enum CrowdsaleStatus {
    Active,
    Finished,
    FeeWithdrawn
}

contract Crowdsale is Ownable {
    uint256 public constant MIN_SALE_PERIOD = 1 weeks;
    uint256 public constant MAX_SALE_PERIOD = 4 weeks;
    uint256 public rate;
    uint256 public startTime;
    uint256 public endTime;
    address public feeReceiver;
    CrowdsaleStatus public status;

    error InvalidStartTime(string message);
    error InvalidEndTime(string message);
    error InvalidFeeReceiver();

    /**
     * Set initia Crowdsael parameters
     * @param _startTime start of the sale
     * @param _endTime  end of the sale
     * @param _rate ETH how much tokes are sold for 1 ETH
     * @param _feeReceiver address to receive fees
     */
    constructor(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _rate,
        address _feeReceiver
    ) Ownable(msg.sender) {
        if (_startTime < block.timestamp) {
            revert InvalidStartTime("Start time must be in future!");
        }

        if (_startTime > block.timestamp + 10 days) {
            revert InvalidStartTime("Start time must be within 10 days!");
        }

        if (_endTime <= _startTime + MIN_SALE_PERIOD) {
            revert InvalidEndTime(
                "End time must be at least MIN_SALE_PERIOD start time!"
            );
        }

        if (_feeReceiver == address(0)) {
            //revert OwnableInvalidOwner(address(0));
            revert InvalidFeeReceiver();
        }

        _startTime = startTime;
        _endTime = endTime;
        _rate = rate;
        _feeReceiver = feeReceiver;
    }
}
