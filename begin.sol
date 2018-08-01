pragma solidity ^0.4.24;

contract SimpleStorage{
    uint storedData;
    
    event Set(uint value); //事件不需要实现
    
    struct Circle {
        uint radius;
    }
    
    Circle c;
    
    //定义函数修改器
    modifier mustOver10 (uint value){
        require(value >= 10);
        _;
    }
    
    function set(uint x) public mustOver10(x){
        storedData = x;
        c = Circle(x);
        emit Set(x);
    }
    
    function get() public constant returns (uint){
        return storedData;
    }
}