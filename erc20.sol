// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract AMKToken {

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint256 private a;
    uint256 private c;

    string  private Name;
    string  private Symbol;
    address public _owner;
     
 
    constructor() {
        _totalSupply = 123400000300000000;
        _owner = msg.sender;
        Name = "AMAR";
        Symbol = "AMK";
    }
    function _Mint(uint256 value) public {
        require(msg.sender == _owner,"only owner can mint");
            _totalSupply += value;
            _balances[_owner] = _totalSupply;
    }
    function _Burn(uint256 value) public {
        require(msg.sender == _owner,"only owner can burn");
            _totalSupply -= value;
            _balances[_owner] = _totalSupply;
    }
    function name() public view returns (string memory){
        return Name;
    }
    function symbol() public view returns (string memory){
        return Symbol;
    }
    function decimals() public pure returns (uint8) {
        return 18;
    }
    function totalSupply() public view  returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) public view  returns (uint256) {
        return _balances[account];
    }
    function transfer(address _to, uint256 _amount) public returns(uint256,uint256) {
            _balances[_to]  +=  _amount;  
            a = _totalSupply - _amount;
            _balances[msg.sender] = a;

        return (_balances[_to],_balances[msg.sender]);
    }
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= c,"Value is greater than approved amount");
        _balances[_owner] -= _value;
        _allowances[_from][msg.sender] -= _value;
        _balances[_to] += _value;
        
        return true;
    }
    function approve(address _spender, uint256 _value) public returns (bool success){
        require(msg.sender == _owner ,"Wrong owner is selected");
        require(_balances[_owner] != 0,"Insufficient supply");
        require(_balances[_owner] <= _totalSupply,"Insufficient supply");
        _allowances[_owner][_spender] = _value;
        c = _allowances[_owner][_spender];

        return true;
    }
    function allowance(address owner, address _spender) public view returns (uint256 remaining){   
        return _allowances[owner][_spender];
    }
}