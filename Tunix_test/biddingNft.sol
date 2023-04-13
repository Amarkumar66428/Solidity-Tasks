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

    struct highbid{
        address participent;
        uint256 tokenId;
        uint256 Prize;
    }
    
    uint256 public HighestPrize;
    address User; 
    uint256 Id;
    address participate;

    mapping(address => mapping(uint256 => ListedToken)) public tokenDetails;
    mapping(address => mapping(uint256 => highbid)) private participates;
    mapping(address => auction)  Biding;

// --------------------------------------------------------Mint----------------------------------------------------
    function _Mint(address user,uint256 tokenId) public{
            
            ListedToken memory details= tokenDetails[user][tokenId];                         // create copy for state declared mapping of TokenDetails of srtuct type ListedToken
            details.tokenId= tokenId; 
            details.owner = msg.sender; 
            tokenDetails[user][tokenId]=details;
            obj.safeMint(user,tokenId);
            User = user;
            Id = tokenId;     
    }
// --------------------------------------------------------To set nft on bidding---------------------------------------
    function setNft_OnBid(address owner,uint256 tokenId,uint256 Prize) public{
        require(tokenDetails[owner][tokenId].owner == owner,"");
        Biding[owner].TokenId = tokenId;
        Biding[owner].Prize = Prize;
    }
// -----------------------------------------------------------to get hightest bid----------------------------------------
    function HighestBid() public view returns(highbid memory){
        return participates[participate][Id];
    }

// ----------------------------------------------------------Here participents can participates------------------------
    function Auction(address Participent, uint256 TokenID,uint256 Prize) public {
       require(msg.sender == obj.ownerOf(TokenID),"Owner is not selected");
       require(Prize != HighestPrize,"this Prize is already given");
       require(Biding[msg.sender].TokenId == TokenID,"Token is not in Auntion");
       require(Prize >= Biding[msg.sender].Prize,"Amount is less than this token Bidding amount");
       require(Participent != obj.ownerOf(TokenID),"owner can't cannot participates");
        
       if(Prize > HighestPrize){
            HighestPrize = Prize;
            highbid memory details= participates[Participent][TokenID];                     // create copy for state declared mapping of participates of struct highbid
            details.participent = Participent ;
            details.tokenId = TokenID;
            details.Prize = Prize;  
            participates[Participent][TokenID]=details;
            participate = Participent;
       }
    }
// --------------------------------------------------------to stop Auction-------------------------------------------
    function EndAuction() public{                                                       
            
            ListedToken memory details= tokenDetails[User][Id];                              // create copy for state declared mapping of TokenDetails of struct ListedToken
            require(msg.sender == details.owner,"Only token owner can End Auction");
            details.tokenId= 0; 
            details.owner = 0x0000000000000000000000000000000000000000; 
            details.wallet += HighestPrize;
            tokenDetails[User][Id]=details;
            
            Biding[User].TokenId = 0;
            Biding[User].Prize = 0;

            ListedToken memory detail= tokenDetails[participate][Id];                         // create copy for state declared mapping of TokenDetails of struct ListedToken
            detail.tokenId= Id; 
            detail.owner = participate; 
            tokenDetails[participate][Id]=detail;
    }
}
