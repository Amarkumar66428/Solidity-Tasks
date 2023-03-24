// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract WorldBank {
   
   address payable public owner;
   uint lastRun = block.timestamp;

   struct Loan {
    uint Loan_Amount;
    uint total_Amount;
    uint Pending_Emi;
    uint MonthlyPayment;
    } 

   mapping(address => uint BankBalance) public balances;
   mapping(address => Loan) public _CarDetails;
   mapping(address => Loan) public _HomeDetails;
   mapping(address => Loan) public _NigiDetails;

// ============================================Deposit=====================================================================
   function _Deposit(uint Amount) public {
    require(address(this).balance != 0,"Insufficient bank fund");
        balances[msg.sender] += Amount;
   }
//=============================================Withdraw==================================================================== 
   function _Withdraw(uint withdrawAmt) public{
    require(address(this).balance != 0,"Insufficient bank fund");
    require(balances[msg.sender] != 0,"Insufficient balance");
    require(balances[msg.sender] >= withdrawAmt,"Insuficient balance"); 
        balances[msg.sender] -= withdrawAmt;
   }
// ============================================Loan========================================================================
     function CarLoan(uint _LoanAmount,uint _month) public {
        require(address(this).balance != 0,"Insufficient bank fund");
        require(address(this).balance >= _LoanAmount ,"Insufficient bank fund");
        uint totalInterest = ( _LoanAmount * 5 * _month ) / 100;
        uint totalAmount = _LoanAmount + totalInterest;
        uint monthlyPayment1 = totalAmount / _month;
        
        owner.transfer(_LoanAmount);
        balances[msg.sender] += _LoanAmount;
        Loan memory details=_CarDetails[msg.sender];
        details.Loan_Amount = _LoanAmount;
        details.total_Amount = totalAmount; 
        details.Pending_Emi = _month; 
        details.MonthlyPayment = monthlyPayment1;  
        _CarDetails[msg.sender]=details;

    }

      function HomeLoan(uint _LoanAmount,uint _month) public {
        require(address(this).balance != 0,"Insufficient bank fund");
        require(address(this).balance >= _LoanAmount ,"Insufficient bank fund");
        uint totalInterest = ( _LoanAmount * 5 * _month ) / 100;
        uint totalAmount = _LoanAmount + totalInterest;
        uint monthlyPayment1 = totalAmount / _month;
        
        owner.transfer(_LoanAmount);
        balances[msg.sender] += _LoanAmount;
        Loan memory details=_HomeDetails[msg.sender];
        details.Loan_Amount = _LoanAmount;
        details.total_Amount = totalAmount; 
        details.Pending_Emi = _month; 
        details.MonthlyPayment = monthlyPayment1;  
        _HomeDetails[msg.sender]=details; 
    }

      function NigiLoan(uint _LoanAmount,uint _month) public {
        require(address(this).balance != 0,"Insufficient bank fun");
        require(address(this).balance >= _LoanAmount ,"Insufficient bank fund");
        uint totalInterest = ( _LoanAmount * 5 * _month ) / 100;
        uint totalAmount = _LoanAmount + totalInterest;
        uint monthlyPayment1 = totalAmount / _month;

        owner.transfer(_LoanAmount);
        balances[msg.sender] += _LoanAmount;
        Loan memory details=_NigiDetails[msg.sender];
        details.Loan_Amount = _LoanAmount;
        details.total_Amount = totalAmount; 
        details.Pending_Emi = _month; 
        details.MonthlyPayment = monthlyPayment1;  
        _NigiDetails[msg.sender]=details;  
    }

// ============================================Pay-Emi=====================================================================

    function carLoan() internal {
        require(block.timestamp - lastRun >  5 seconds , "Need to wait 5 seconds");
        Loan memory details=_CarDetails[msg.sender];
        require(details.Pending_Emi != 0,"Didn't have any car loan");
          balances[msg.sender] -= details.MonthlyPayment;
          details.Pending_Emi -= 1;
           
          lastRun = block.timestamp;

        if(details.Pending_Emi == 0){
           details.total_Amount = 0;
           details.MonthlyPayment = 0;
           details.Loan_Amount = 0;
      }
      _CarDetails[msg.sender]=details;
    }

    function homeLoan() internal {
        require(block.timestamp - lastRun >  5 seconds, "Need to wait 5 seconds");
        Loan memory details=_HomeDetails[msg.sender];
        require(details.Pending_Emi != 0,"Didn't have any home loan");
          balances[msg.sender] -= details.MonthlyPayment;
          details.Pending_Emi -= 1;
         
        lastRun = block.timestamp;

        if(details.Pending_Emi == 0){
          details.total_Amount = 0;
          details.MonthlyPayment = 0;
          details.Loan_Amount = 0;  
      }
      _HomeDetails[msg.sender]=details;
    }

    function nigiLoan() internal {
        require(block.timestamp - lastRun >  5 seconds, "Need to wait 5 seconds");
        Loan memory details=_NigiDetails[msg.sender];
        require(details.Pending_Emi != 0,"Didn't have any nigi loan");
          balances[msg.sender] -= details.MonthlyPayment;
          details.Pending_Emi -= 1;

          lastRun = block.timestamp;

        if(details.Pending_Emi == 0){
          details.total_Amount = 0;
          details.MonthlyPayment = 0;
          details.Loan_Amount = 0;  
      }
       _NigiDetails[msg.sender]=details;
    }

function PayEmi(string memory Loan_Type) public {
        if (keccak256(bytes(Loan_Type)) == keccak256(bytes("car")))  {
            carLoan();
        }
        else if (keccak256(bytes(Loan_Type)) == keccak256(bytes("home")))  {
            homeLoan();
        } 
        else if (keccak256(bytes(Loan_Type)) == keccak256(bytes("nigi")))  {
            nigiLoan();
        } 
        else {
            revert("Invalid Loan type");
        }
    }

//=============================================Admin=======================================================================

   constructor() {
      owner = payable(msg.sender);
    }
     
    modifier Onlyadmin{
      require(owner==msg.sender,"Not correct admin");
      require(msg.value != 0,"Zero value sent");
      _;
    }

    function _AddFund() public Onlyadmin payable returns(uint){
      uint contBal = address(this).balance;
      return contBal;
    }
//=============================================ContractBal=================================================================
function contractBal() public view returns(uint)
    {
        uint contBal = address(this).balance;
        return contBal;
    }
}


