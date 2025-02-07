// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

struct Vote {
    address shareholder;
    uint256 shares;
    //uint256 timestamp;
}

contract Crowdfunding {
    mapping(address => uint256) public shares;
    Vote[] public votes;
    uint256 public a;

    function addShares(address receiver) external {
        address b;
        uint256 c;
        uint256 a = 5;
        // totalShares += amount;
        shares[receiver] += 1000;
    }

    function vote(address holder) external {
        votes.push(
            Vote({
                shareholder: holder,
                shares: shares[holder]
                //timestamp: block.timestamp
            })
        );
    }
}

contract Test {
    uint256[5] public arr = [5, 3];

    uint256[] public dynamicArr = [1, 2, 3, 4, 5];

    function addNumberDynamic(uint256 value) external returns(uint256) {
        dynamicArr.push(value);

        return dynamicArr.length;
    }

    function addNumber() external view returns (uint256) {
        uint256 res;

        for (uint256 i = 0; i < arr.length; i++) {
            res += arr[i];
        }

        return res;
    }
}