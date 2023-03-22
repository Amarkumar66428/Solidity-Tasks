// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract LedgerBalance {
   
   address admin;
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

// =============================================Deposit===================================================================
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
        _CarDetails[msg.sender].Loan_Amount = _LoanAmount;
        _CarDetails[msg.sender].total_Amount = totalAmount; 
        _CarDetails[msg.sender].Pending_Emi = _month; 
        _CarDetails[msg.sender].MonthlyPayment = monthlyPayment1;  
    }

      function HomeLoan(uint _LoanAmount,uint _month) public {
        require(address(this).balance != 0,"Insufficient bank fund");
        require(address(this).balance >= _LoanAmount ,"Insufficient bank fund");
        uint totalInterest = ( _LoanAmount * 5 * _month ) / 100;
        uint totalAmount = _LoanAmount + totalInterest;
        uint monthlyPayment1 = totalAmount / _month;
        
        owner.transfer(_LoanAmount);
        balances[msg.sender] += _LoanAmount;
        _HomeDetails[msg.sender].Loan_Amount = _LoanAmount;
        _HomeDetails[msg.sender].total_Amount = totalAmount; 
        _HomeDetails[msg.sender].Pending_Emi = _month; 
        _HomeDetails[msg.sender].MonthlyPayment = monthlyPayment1;  
    }

      function NigiLoan(uint _LoanAmount,uint _month) public {
        require(address(this).balance != 0,"Insufficient bank fun");
        require(address(this).balance >= _LoanAmount ,"Insufficient bank fund");
        uint totalInterest = ( _LoanAmount * 5 * _month ) / 100;
        uint totalAmount = _LoanAmount + totalInterest;
        uint monthlyPayment1 = totalAmount / _month;

        owner.transfer(_LoanAmount);
        balances[msg.sender] += _LoanAmount;
        _NigiDetails[msg.sender].Loan_Amount = _LoanAmount; 
        _NigiDetails[msg.sender].total_Amount = totalAmount;
        _NigiDetails[msg.sender].Pending_Emi = _month; 
        _NigiDetails[msg.sender].MonthlyPayment = monthlyPayment1;  
    }

// ==========================================================Emi===================================================================

    function carLoan() internal {
        require(block.timestamp - lastRun >  5 seconds , 'Need to wait 5 seconds');
        require(_CarDetails[msg.sender].Pending_Emi != 0,"didn't have any car loan");
          balances[msg.sender] -= _CarDetails[msg.sender].MonthlyPayment;
          _CarDetails[msg.sender].Pending_Emi -= 1;

          lastRun = block.timestamp;

         if(_CarDetails[msg.sender].Pending_Emi == 0){
          _CarDetails[msg.sender].total_Amount = 0;
          _CarDetails[msg.sender].MonthlyPayment = 0;
          _CarDetails[msg.sender].Loan_Amount = 0; 
      }
    }

    function homeLoan() internal {
        require(block.timestamp - lastRun >  5 seconds, 'Need to wait 5 seconds');
        require(_HomeDetails[msg.sender].Pending_Emi != 0,"didn't have any home loan");
          balances[msg.sender] -= _HomeDetails[msg.sender].MonthlyPayment;
          _HomeDetails[msg.sender].Pending_Emi -= 1;

        lastRun = block.timestamp;

         if(_HomeDetails[msg.sender].Pending_Emi == 0){
          _HomeDetails[msg.sender].total_Amount = 0;
          _HomeDetails[msg.sender].MonthlyPayment = 0;
          _HomeDetails[msg.sender].Loan_Amount = 0; 
      }
    }

    function nigiLoan() internal {
        require(block.timestamp - lastRun >  5 seconds, 'Need to wait 5 seconds');
        require(_NigiDetails[msg.sender].Pending_Emi != 0,"didn't have any nigi loan");
          balances[msg.sender] -= _NigiDetails[msg.sender].MonthlyPayment;
          _NigiDetails[msg.sender].Pending_Emi -= 1;

          lastRun = block.timestamp;

         if(_NigiDetails[msg.sender].Pending_Emi == 0){
          _NigiDetails[msg.sender].total_Amount = 0;
          _NigiDetails[msg.sender].MonthlyPayment = 0;
          _NigiDetails[msg.sender].Loan_Amount = 0; 
      }
    }

function PayEmi(string memory Loan_Type) public {
        if (keccak256(bytes(Loan_Type)) == keccak256(bytes("car")))  {
            carLoan();
        }
        else if (keccak256(bytes(Loan_Type)) == keccak256(bytes("home")))  {
            homeLoan();
        } else if (keccak256(bytes(Loan_Type)) == keccak256(bytes("nigi")))  {
            nigiLoan();
        } 
        else {
            revert("Invalid Loan type");
        }
    }

//=================================================Admin================================================================
   constructor() {
      admin = msg.sender; 
      owner = payable(msg.sender);
    }
     
    modifier Onlyadmin{
      require(admin==msg.sender,"Not correct admin");
      require(msg.value != 0,"Zero value sent");
      _;
    }

    function _AddFund() public Onlyadmin payable returns(uint){
      uint contBal = address(this).balance;
      return contBal;
    }
//================================================ContractBal============================================================
function contractBal() public view returns(uint)
    {
        uint contBal = address(this).balance;
        return contBal;
    }
}
contract Updater {
   function Deposit() public returns (uint) {
      LedgerBalance ledgerBalance = new LedgerBalance();
      ledgerBalance._Deposit(10);
      return ledgerBalance.balances(address(this));
   }
}


