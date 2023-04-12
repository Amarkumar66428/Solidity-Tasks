// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract ERC721market is ERC721, ERC721Burnable {
    constructor() ERC721("AMAR","AMK") {}
    

    address private marketadd;
    
    function setter(address _add) public  {
     marketadd = _add;
    }
    
    function safeMint(address to, uint256 tokenId) external {
        require(msg.sender == marketadd,"only market can mint");
        _safeMint(to, tokenId);
    }
}

// ----------------------------------------------------------------------------------------------------------------------------------
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

contract ERC1155market is ERC1155, ERC1155Burnable {
    constructor() ERC1155("") {}
    
    address private commonMarket;
    address public marketadd;

    function setter(address _add) public  {
     marketadd = _add;
    }
    function getter() public view returns(address){
        return marketadd;
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) external {
         require(msg.sender == marketadd,"only Market can mint+++++");
        _mint(account, id, amount, data);
    }
}

// ---------------------------------------------------------------------------------------------------------------------------------
contract CommonMarket{
    ERC721market obj = new ERC721market();
    ERC1155market obj1 = new ERC1155market();

    uint256 i;
    uint256 lastRun = block.timestamp;

    constructor(address Erc721market, address Erc1155market){
        obj = ERC721market(Erc721market);
        obj1 = ERC1155market(Erc1155market);

        obj.setter(address(this));
        obj1.setter(address(this));
        i = 1;
    }
   
    struct ListedToken{
        string  MarketType;
        uint256 tokenId;
        uint256 Prize;
        uint256 amount;
        uint256 TokenOnSale;
        bytes   data;
        address owner;
        uint256 wallet;
    }

    struct VestNft{
        uint256 TokenId;
        uint256 amount;
    }
    
    mapping(address => mapping(uint256 => uint256)) private TokenPrize;
    mapping(address => mapping(uint256 => ListedToken)) public tokenDetails;
    mapping(address => uint256) public Token;
    mapping(address => uint256) private OnSaleId;
    mapping(address => uint256) public Rovality;
    mapping(address => mapping(address => VestNft)) private vestNft;

// -----------------------------------------------------------------------------mint------------------------------------------------------------------
    function mint(address _account,uint256 _amount) public {
        require(_amount != 0,"Zero amount sent");
        uint token = i++;
        
        if(_amount == 1){
            
            ListedToken memory details = tokenDetails[_account][i];

            details.MarketType = "ERC721";
            details.tokenId = token;
            details.Prize = 0;
            details.amount = _amount;
            details.owner = _account;
            details.TokenOnSale = 0;
            obj.safeMint(_account,token);
            tokenDetails[_account][token] = details;
          
        }
        else{
            ListedToken memory details = tokenDetails[_account][i];

            details.MarketType = "ERC1155";
            details.tokenId = token;
            details.owner = _account;
            details.amount = _amount;
            details.data = '0x00';
            obj1.mint(_account, token, _amount, '0x00');
            tokenDetails[_account][token] = details;   
        }   
    }

// --------------------------------------------------------------------------setForSale---------------------------------------------------------
    function setForSell(address owner,uint256 _id, uint256 _amount,uint256 _Prize) public {
        
        ListedToken memory details = tokenDetails[owner][_id];
        require(tokenDetails[owner][_id].tokenId == _id,"Didn't have this kind of token");

        if(tokenDetails[owner][_id].amount == 1){
            require(owner == obj.ownerOf(_id),"Only ownable can access");
            require(_amount == 1,"AS it is erc721, Amount should be 1");
        
                details.tokenId = _id;
                details.Prize = _Prize;
                TokenPrize[owner][_id] = _Prize; 
                details.TokenOnSale = 1;
                details.owner = owner;
        }
        else{
            require(_amount <= details.amount,"Amount is greater than Available Tokens");
            require(tokenDetails[owner][_id].owner == owner,"Only ownable can access");

                details.tokenId = _id;
                details.Prize = _Prize;
                TokenPrize[owner][_id] = _Prize; 
                details.owner = owner;
                OnSaleId[owner] = _amount;
                details.TokenOnSale = OnSaleId[owner];
                details.data = '0x00';
        }
            tokenDetails[owner][_id] = details;
    }
// -------------------------------------------------------------------------------buyToken-------------------------------------------------------
    function buyToken(address owner,uint256 TokenId,uint256 amount,address Buyer,uint256 Prize) public {

        require(Buyer != owner,"Owner is selected");
        require(tokenDetails[owner][TokenId].owner == owner,"Wrong owner");
        require(tokenDetails[owner][TokenId].tokenId == TokenId,"Owner Didn't have this kind of token");

        uint256 Tp =TokenPrize[owner][TokenId];

        if(amount == 1){
            ListedToken memory details = tokenDetails[owner][TokenId];
            require(Prize == TokenPrize[owner][TokenId],"Invalid Prize");
            require(tokenDetails[owner][TokenId].Prize != 0 || tokenDetails[owner][TokenId].amount != 0,"This TokenId is not for sale");
            
                obj.safeTransferFrom(owner,Buyer,TokenId);
                details.MarketType = " ";
                details.tokenId = 0;
                details.amount = 0;
                details.TokenOnSale = 0;
                Tp -= (Tp* 10) / 100;
                Rovality[address(this)] += details.Prize - Tp;
                details.wallet += Tp;
                details.Prize = 0;
                tokenDetails[owner][TokenId] = details;

            ListedToken memory Details = tokenDetails[Buyer][TokenId];
                Details.MarketType = "ERC721";
                Details.tokenId = TokenId;
                Details.Prize = 0;
                Details.amount = amount;
                Details.TokenOnSale = 0;
                Details.data = '0x00';
                Details.owner = Buyer;
                tokenDetails[Buyer][TokenId] = Details;

        }
        else{

            ListedToken memory details = tokenDetails[owner][TokenId];
            require(Prize == TokenPrize[owner][TokenId],"Invalid Prize");
                obj1.safeTransferFrom(owner,Buyer,TokenId,amount,'0x00');
                details.MarketType = "  ";
                details.tokenId = TokenId;
                details.amount -= amount;
                OnSaleId[owner] -= amount;
                details.TokenOnSale -= amount;
                details.data = '0x00';            
                details.owner = owner;
                Tp -= (Tp * 10) / 100;
                Rovality[address(this)] = details.Prize - Tp;
                details.wallet = Tp;
                tokenDetails[owner][TokenId] = details;

            ListedToken memory detail = tokenDetails[Buyer][TokenId];
                detail.MarketType = "ERC1155";
                detail.tokenId = TokenId;
                detail.amount = amount;
                detail.data = '0x00';
                detail.owner = Buyer;
                tokenDetails[Buyer][TokenId] = detail;
        }     
    }

// ---------------------------------------------------------Vestnft-------------------------------------------
    
    uint256 time ;
    
    function _VestNft(uint256 TokenId,uint256 amount, uint256 duration) public {
        ListedToken memory details = tokenDetails[msg.sender][TokenId];

        require(details.tokenId == TokenId,"tokenId is not minted");
        require(details.owner == msg.sender," only Token Owner can vest nft");
        time = block.timestamp + duration * 60;
        
        Token[msg.sender]= details.tokenId;
        if(details.amount == amount){
        details.tokenId = 0;
        details.MarketType = "0";
        details.owner = 0x0000000000000000000000000000000000000000;
        }
        
        vestNft[address(this)][msg.sender].amount = amount;
        details.amount -=  vestNft[address(this)][msg.sender].amount;

        tokenDetails[msg.sender][TokenId] = details;
    }

    function getVestNft(address owner,uint256 TokenId) public {
        ListedToken memory details = tokenDetails[owner][TokenId];
        VestNft memory detail = vestNft[address(this)][owner];
        require(Token[owner] == TokenId,"owner don't have this tokenId");
        require(block.timestamp >= time, "Nft is Locked Wait for Taken duration for unlock");
        require(details.amount != detail.amount + details.amount,"Token is reedemed by owner");
        
        details.tokenId = TokenId;
        details.amount += detail.amount;
        detail.amount = 0;

        vestNft[address(this)][owner] = detail;
        tokenDetails[owner][TokenId] = details;
    }
}