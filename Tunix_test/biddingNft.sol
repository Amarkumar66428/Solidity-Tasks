// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract MyToken is ERC721, ERC721Burnable{
    constructor() ERC721("AMAR", "AMK") {}

    function safeMint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }
}

contract MyNftmarket {

    MyToken obj = new MyToken();

    constructor(address Market){
        obj = MyToken(Market);
    }

    struct ListedToken{
        uint256 tokenId;
        address owner;
        uint256 wallet;
    }

    struct auction{
        uint256 TokenId;
        uint256 Prize;
    }

    mapping(address => mapping(uint256 => ListedToken)) public tokenDetails;
    mapping(address => auction) public Biding;
    mapping(address => mapping(uint256 => uint256)) map;
    
    address User; 
    uint256 Id;
    function _Mint(address user,uint256 tokenId) public{
            
            ListedToken memory details= tokenDetails[user][tokenId];                         // create copy for state declared mapping of TokenDetails
            details.tokenId= tokenId; 
            details.owner = msg.sender; 
            tokenDetails[user][tokenId]=details;
            obj.safeMint(user,tokenId);
            User = user;
            Id = tokenId;
        
    }

    function setNft_OnBid(address owner,uint256 tokenId,uint256 Prize) public{
        require(tokenDetails[owner][tokenId].owner == owner,"");
        Biding[owner].TokenId = tokenId;
        Biding[owner].Prize = Prize;
    }
    
    uint256 public HighestPrize;
    address participent;
    uint256 _Id;


    function Auction(address Participent, uint256 TokenID,uint256 Prize) public {
       require(msg.sender == obj.ownerOf(TokenID),"Owner is not selected");
       require(Prize != HighestPrize,"this Prize is already given");
       require(Biding[msg.sender].TokenId == TokenID,"Token is not in Auntion");
       require(Prize >= Biding[msg.sender].Prize,"Amount is less than this token Bidding amount");
       require(Participent != obj.ownerOf(TokenID),"owner can't cannot participates");
       
       participent = Participent;
       _Id = TokenID;

       map[Participent][TokenID] = Prize;
        
       if(Prize > HighestPrize){
            HighestPrize = Prize;
            
       }
    }

    function EndAuction() public{                                                       
            
            ListedToken memory details= tokenDetails[User][Id];                              // create copy for state declared mapping of TokenDetails
            require(msg.sender == details.owner,"Only token owner can End Auction");
            details.tokenId= 0; 
            details.owner = 0x0000000000000000000000000000000000000000; 
            details.wallet += HighestPrize;
            tokenDetails[User][Id]=details;
            
            Biding[User].TokenId = 0;
            Biding[User].Prize = 0;

            ListedToken memory detail= tokenDetails[participent][Id];
            detail.tokenId= Id; 
            detail.owner = participent; 
            tokenDetails[participent][Id]=detail;

    }
}
