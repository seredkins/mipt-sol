// SPDX-License-Identifier: MIT 

pragma solidity 0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Samolet.sol";

interface Token {
    function mint(address _to, uint _amount) external;
}

contract Crowdsale is Ownable {

    using SafeMath for uint;
    
    uint private end;
    uint private totalETH;
    uint private j = 0;
    bool private wasOpen = true;
    uint private maxETH;
    uint private rate;
    address private tokenAddr;

    constructor(uint _max = 10, uint _rate = 10) Ownable(msg.sender) {
        end = block.timestamp + 28 days;
        maxETH = _max ether;
        rate = _rate;
    }

    function setTokenAddr(address _addr) onlyOwner {
        tokenAddr = _addr;
    }

    function restartCrowdsale(uint _max = 10, uint _rate = 10, address _addr) external onlyOwner {
        end = block.timestamp + 28 days;
        maxETH = _max ether;
        rate = _rate;
        wasOpen = true;
        tokenAddr = _addr;
    }

    function _finishSale() private returns (bool) {
        require(wasOpen);

        if (block.timestamp <= end) {
            return true;
        } else {
            address(_owner).transfer(totalETH);
            totalETH = 0;
            wasOpen = false;
            return false;
        }
    }

    function receiveETH() external payable {
        require(_finishSale(), "sale is finished");
        require(totalETH.add(msg.value) <= MAX_ETH, "send less ETH");

        uint _value = msg.value;
        totalETH = totalETH.add(_value);
        Token token = Token(tokenAddr);
        token.mint(msg.sender, _value.mul(rate).div(1e18));
    }
}
