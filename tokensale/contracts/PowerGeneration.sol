pragma solidity ^0.5.2;


import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/payment/escrow/RefundEscrow.sol";


contract PowerToken is ERC20Detailed,ERC20,ERC20Mintable{

    //constructor (string memory name, string memory symbol, uint8 decimals,uint256 _totalSupply) 
    constructor()
    ERC20Detailed("Sparrow Power","SPR",10)
    public {
                //_mint(msg.sender, _totalSupply);
    }
    
    function mint(address to,uint256 value) public onlyMinter returns (bool){
        _mint(to,value);
        return true;
    }
    
    
}

contract PowerTokenGeneration {
        using SafeMath for uint256;
        uint256 private _rate;
        uint256 private _weiRaised;
        uint256 public startDate = now + 0 minutes;
        uint256 public freezingDate = now + 30 minutes;
        uint256 public refundDate = now + 1 hours;
        uint256 public lockDate = now + 1.5 hours;


        //number of wei for one token
        uint private oneTokenInWei = 10 ** 18; //1 eth

        uint256 public minContributionAmount = 10 ** 17; // 0.1 ETH

        mapping (address => uint256) _escrow;

        PowerToken public token;
        

        // Sparrow Address to keep the money
        address beneficiaryAccount;        
        
        //define events here
        event TokenPurchase(address purchaser, uint256 amountInWei);
   


        constructor (PowerToken _token,uint256 rate) public{
            require(rate>0);   
            token=_token;       
            beneficiaryAccount = msg.sender;
            _rate = rate;
           }

        //Token buyer contribute ETH in exchange of POWER        
        function contribute() external payable{
            require(now > startDate && now < freezingDate);
            require(msg.value > minContributionAmount);
            uint256 weiAmount = msg.value;
            _escrow[msg.sender] = _escrow[msg.sender].add(weiAmount);
            _weiRaised = _weiRaised.add(weiAmount);
            emit TokenPurchase(msg.sender,weiAmount);

            //token.mint(address(this),tokens);
            //ethEscrow[msg.sender] = ethEscrow[msg.sender].add(weiAmount);
            //tokenEscrow[msg.sender] = tokenEscrow[msg.sender].add(token);
           }

        //Check balance of any contributor address
        function checkWeiBalance() public view returns(uint256){
            return _escrow[msg.sender];
        }

        //Check token balance of any contributor address
        function checkTokenBalance() public view returns(uint256){
            return getTokenAmount(_escrow[msg.sender]);
        }

        //check how many POWER can be generated in the future
        function checkTotalTokenBalance() public view returns(uint256){
            //return _weiRaised.mul(_rate)/oneTokenInWei;
            return getTokenAmount(_weiRaised);
        }
        
        function getTotalWeiRaised() public view returns(uint256){
            return _weiRaised;
        }
    
        //Return number of POWER token with the Rate
        function getTokenAmount(uint256 weiAmount) internal view returns (uint256){
            return weiAmount.mul(_rate)/oneTokenInWei;
        }
        
        //Token buyer confirm and claim their POWER token
        function claimPowerToken() public{
            require(_escrow[msg.sender] > 0);
            //require(now > lockDate);
            uint256 weiAmount = _escrow[msg.sender];
            uint256 tokens = getTokenAmount(weiAmount);
            token.mint(msg.sender,tokens);
            //token.transfer(msg.sender,amount);
            _escrow[msg.sender] = _escrow[msg.sender].sub(weiAmount);
        }
           
        //Token buyer claim refund
        function refund() public{
            require(now > refundDate && now < lockDate);
            require(_escrow[msg.sender] > 0);
            uint amount = _escrow[msg.sender];
            _weiRaised = _weiRaised.sub(amount);
            _escrow[msg.sender] = _escrow[msg.sender].sub(amount);
            msg.sender.transfer(amount);
        }
    
        //admin draw all the ETH out from the contract, this should be only done after refund period. 
        function transferFunds() public{
            require(now > lockDate);
            require(msg.sender == beneficiaryAccount);
            msg.sender.transfer(_weiRaised);
            _weiRaised = 0;
        }
        
    
    
}