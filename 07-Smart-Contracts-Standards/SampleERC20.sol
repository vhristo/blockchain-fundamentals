// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

error InsufficientBalance();
error InsufficientApproval();

contract ERC20 {
    string public name;
    string public symbol;
    uint8 public decimals = 3; // 1000 => 1 token, 1500 => 1.5 tokens;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    // approver => spender => amount
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;

        uint256 supply = 1000 * 10**decimals;
        balanceOf[msg.sender] = supply;
        totalSupply = supply;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        if (balanceOf[msg.sender] < _value) {
            revert InsufficientBalance();
        }

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        if (allowance[_from][msg.sender] < _value) {
            revert InsufficientApproval();
        }

        allowance[_from][msg.sender] -= _value;

        if (balanceOf[_from] < _value) {
            revert InsufficientBalance();
        }

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }
}
