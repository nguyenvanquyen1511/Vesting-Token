//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "./ERC20.sol";
import "hardhat/console.sol";

contract VestingToken{
    // địa chỉ người nhận token
    address public receiver;
    // thời gian bắt đầu trả token
    uint public timeStart;
    // thời gian chờ sau mỗi lần trả token
    uint public timeCooldown = 0;
    // tổng thời gian trả token
    uint public timeVesting;
    // thời gian kết thúc
    uint public timeEnd;
    // địa chỉ người khởi tạo
    address public minter;
    // địa chỉ token
    IERC20 public myToken;
    
    constructor(address _receiver, uint _timeVesting, IERC20 _myToken) {
        require(_receiver != msg.sender || _receiver != address(0));
        receiver = _receiver;
        timeStart = block.timestamp;
        timeVesting = _timeVesting;
        timeEnd = block.timestamp + _timeVesting;
        minter = msg.sender;
        myToken = IERC20(_myToken);
    }
    // số lượng token trả trong 1 khoảng thời gian
    function tokenReleasePerHour() public view returns(uint) {
        return myToken.totalSupply() * 15 / timeVesting;
    }
    // trả token
    function release() public {
        require(block.timestamp <= timeEnd);
        require(myToken.balanceOf(minter) != 0);
        uint amount = releaseAmount();
        uint timeIncrease = amount / tokenReleasePerHour();
        require(amount !=0, "Loi");
        myToken.transfer(receiver, amount);
        // tăng thời gian chờ sau mỗi lần trả token
        timeCooldown += timeIncrease * 15;
    }
    // số lượng token có thể trả
    function releaseAmount() public view returns(uint) {
        if(block.timestamp < timeStart + timeCooldown) {
            return 0;
        } else if(timeCooldown == 0) { // trường hợp chưa nhận token lần nào
            return (((block.timestamp - timeStart - timeCooldown) / 15) * tokenReleasePerHour() + tokenReleasePerHour()); 
        } else { // trường hợp đã nhận token
            uint n = (block.timestamp - timeStart - timeCooldown) / 15;
            return n * tokenReleasePerHour();
        }
    }
}

