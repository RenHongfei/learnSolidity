pragma solidity ^0.4.20;

interface token{
    function transfer(address _to, uint amount) external;
}

contract Ico {
    
    uint public fundingGoal;
    uint public deadline;
    uint public price;
    uint public fundAmount;
    token public tokenReward;
    address public beneficiary;
    
    mapping (address => uint) public balanceOf;
    
    event FundTransfer(address backer, uint amount);
    event GoalReached(bool success);
    
    // 0xdc04977a2078c8ffdf086d618d1f961b6c546222
    constructor(uint fundingGoalInEthers, 
    uint durationInMinutes,
    uint etherCostofEachToken,
    address addressOfToken){
        beneficiary = msg.sender;
        fundingGoal = fundingGoalInEthers * 1 ether;
        deadline = now + durationInMinutes * 1 minutes;
        price = etherCostofEachToken * 1 ether; //1eth = 10 ** 18 wei
        tokenReward = token(addressOfToken);
    }
    
    function () public payable{
        
        require(now < deadline);
        
        uint amount = msg.value; //wei
        uint tokenAmount = amount / price;
        balanceOf[msg.sender] += amount;
        fundAmount += amount;
        tokenReward.transfer(msg.sender, tokenAmount);
         
        emit FundTransfer(msg.sender,amount);
    }
    
    modifier afterDeadline(){
        require(now >= deadline);
        _;
    }
    
    function checkGoalReached() public afterDeadline{
        if(fundAmount >= fundingGoal){
            emit GoalReached(true);
        }
    }
    
    function withdrawal() public afterDeadline{
        if (fundAmount >= fundingGoal){
            if(beneficiary == msg.sender){
                beneficiary.transfer(fundAmount);
            }
        }else{
            msg.sender.transfer(balanceOf[msg.sender]);
            balanceOf[msg.sender] = 0;
        }
        
    }
}