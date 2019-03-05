let Web3 = require('web3');
const AbiOfContract = require("./ABI.json");
const contractAddress="0x54340dbab1a260a20483ebaf684aed891776fac5";
const ethereumNodeUrl = "https://ropsten.infura.io/v3/237d5f32eea74bbb853c07bb7cea47fa";
var express = require('express');
var connected = false;
let web3;
var app = express();
var tokenContract;


app.listen(3000,()=>{
  web3 = new Web3(new Web3.providers.HttpProvider(ethereumNodeUrl));
  web3.eth.net.isListening()
    .then(()=>{
      console.log('web3 is connected to the ethereum node');
 
      //contract
      tokenContract = new web3.eth.Contract(AbiOfContract, contractAddress);
      console.log('testing contract connection...')

      tokenContract.methods.symbol.call()
        .then((result)=>{
          console.log("token Symbol: "+result);
          connected = true;
          console.log("Smart contract connected");
        })
        .catch((err)=>console.log(err));
            

    })
    .catch(()=>{console.log('There is a problem on ethereum node connection')})
	console.log('restful server running at port 3000');
});



app.get('/getTokenSymbol',(req,res)=>{
  if(connected){
        tokenContract.methods.symbol.call()
        .then((result)=>{res.status(200).send(result)})
        .catch((err)=>res.status(500).send(err));
  }else{
    res.status(500).send("Ethereum node not connected")
  }
 });

