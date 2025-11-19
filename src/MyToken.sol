// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.8.31;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    uint8 private _customDecimals;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 totalSupply_
    ) ERC20(name_, symbol_) {
        _customDecimals = decimals_;

        _mint(msg.sender, totalSupply_ * (10 ** decimals_));
    }

    function decimals() public view override returns (uint8) {
        return _customDecimals;
    }
}
