// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

interface AMKinterface{
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) external view returns (uint256);

    function ownerOf(uint256 _tokenId) external view returns (address);

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

    function approve(address _approved, uint256 _tokenId) external payable;

}

contract AMKToken is AMKinterface {

    mapping(address => uint256) private _balances;
    mapping(address => uint256) private _notoken;
    mapping(uint256 => address) private _address;
    mapping(address => mapping(address => uint256)) private _approval;

    string  private Name;
    string  private Symbol;
    address public _owner;
     
    constructor() {
        _owner = msg.sender;
        Name = "AMAR";
        Symbol = "AMK";
    }
    function safeMint(uint256 _TokenId) public {
        require(msg.sender == _owner,"Only owner can burn");
            _balances[msg.sender] = _TokenId;
            _address[_TokenId] = _owner;
            _notoken[msg.sender] += 1;
    }
    function name() public view returns (string memory){
        return Name;
    }
    function symbol() public view returns (string memory){
        return Symbol;
    }
    function balanceOf(address owner) external view returns (uint256)
    {
        return _notoken[owner];
    }
    function ownerOf(uint256 _tokenId) external view returns (address)
    {
        return _address[_tokenId];
    }
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable
    {
        require(_tokenId == _balances[_from] || _tokenId == _balances[_owner],"didn't have this kind of token");
        _balances[_from] =  _balances[_to];
        _notoken[_from] -= 1;

        _balances[_to] = _tokenId;
        _address[_tokenId] = _to;
        _notoken[_to] += 1;     
    }
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable
    {
        require(_approval[_from][msg.sender] == _tokenId,"");
        _approval[_from][msg.sender] -= _tokenId;

        _balances[_owner] =  _balances[_to];
        _notoken[_owner] -= 1;

        _balances[_to] = _tokenId;
        _address[_tokenId] = _to;
        _notoken[_to] += 1;
    }
    function approve(address _approved, uint256 _tokenId) external payable
    {
        require(msg.sender == _owner,"only owner can approve");
        require(_tokenId == _balances[_owner] ,"Owner didn't have this kind of token");
         _approval[_owner][_approved] = _tokenId;
    }
}
