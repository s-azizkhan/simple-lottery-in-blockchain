// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public participants;

    constructor(){
        manager = msg.sender; //Global Variable & here I assigned manager to who was deploy this contract
    }

    receive() external payable{
        require(msg.value ==1 ether); //minimum amount required
        participants.push(payable(msg.sender));

    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager );
        return address(this).balance;
    }

    function generateRandom() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function selectWinner() public{
        require(msg.sender == manager );
        require(participants.length >= 3); //minimum 3 member required
        uint r = generateRandom();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
}
