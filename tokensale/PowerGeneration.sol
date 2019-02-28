pragma solidity ^0.5.2;


import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";


contract PowerToken  is ERC20Detailed,ERC20,ERC20Mintable{

    //constructor (string memory name, string memory symbol, uint8 decimals,uint256 _totalSupply) 
    constructor()
    ERC20Detailed("Sparrow Power","SPR",10)
    public {
                //_mint(msg.sender, _totalSupply);
    }
    
    function mint(address to,uint256 value) public returns (bool){
        _mint(to,value);
        return true;
    }
    
    function myFunc() public returns(bool){
        return true;
    }
    
}

contract PowerGeneration{
         using SafeMath for uint256;

           PowerToken public token;
           address tokenOwner;
           mapping (address => uint256) investors;
           
           constructor (PowerToken _token) public{
            token=_token;       
            tokenOwner = msg.sender;
           }
           function contribute() external payable{
               //token.mint(tokenOwner,msg.value);
               uint256 value = msg.value;
               token.mint(address(this),msg.value);
               //investors[msg.sender] = msg.value;
               investors[msg.sender] = investors[msg.sender].add(value);
                
           }
           function checkBalance() public view returns(uint){
               return investors[msg.sender];
           }
           
           function claimToken() public{
               uint amount = investors[msg.sender];
               //token.approve(msg.sender,1);
               //token.transferFrom(tokenOwner,msg.sender,10);
                token.transfer(msg.sender,amount);
                investors[msg.sender] = investors[msg.sender].sub(amount);

           }
    
}
