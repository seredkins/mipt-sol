// SPDX-License-Identifier: MIT 

pragma solidity 0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Samolet is Ownable, ERC20 {


    // need to change hardcoded address to existing Crowdsale address when it deployed
    constructor() Ownable(0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c) ERC20("Samolet", "SMLT") {}

    function mint(address _to, uint _amount) external onlyOwner {
        require(_to != address(0), "Invalid receiver");
        _mint(_to, _amount);
    }

}