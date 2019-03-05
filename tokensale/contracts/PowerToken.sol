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
