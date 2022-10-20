// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';
import './Libraries/Counters.sol';

    /*
    Building our minting function
     1. NFT has to point to an address
     2. Keep track of the token ids
     3. Keep track of token owner addresses to token ids
     4. Keep track of how many tokens an owner address has
     5. Create an event that emits a transfer log - contract
     address, where is it being minted to, the id

    */

contract ERC721 is ERC165, IERC721 {

    using SafeMath for uint256;
    using Counters for Counters.Counter;

    //I just comment events because they're already inherited
    /*event Transfer (
        address indexed from,
        address indexed to,
        uint indexed tokenId);

    event Approval (
        address indexed owner,
        address indexed to,
        uint indexed tokenId);
    */
    //A mapping create a hash table of key pair values
    //Mapping from token id to owner address

    mapping (uint256 => address) private _tokenOwner;

    //mapping from owner to number of owned tokens
    mapping (address => Counters.Counter) private _ownerTokenCount;

    //mapping from token Id to approval addresses
    mapping (uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterace(bytes4(keccak256('balanceOf(bytes4)')^
        keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    }


    function _mint(address to, uint tokenId) internal virtual {
        //cannot mint to a zero address
        require(to != address(0), "Not minting to a 0 address");
        //cannot mint a tokenId that already exist
        require(!_checkId(tokenId), "The tokenId already exists");
        //adding a new address with the Id
        _tokenOwner[tokenId] = to;
        //adding the count of token to the address that mint it
        _ownerTokenCount[to].increment();
        emit Transfer(address(0), to, tokenId);
    }
    function _checkId(uint tokenId) internal view returns(bool) {
        //let set the owner of the token from 
        //our mapping
        address owner = _tokenOwner[tokenId];
        //setting the thruthness of the statement
        return owner != address(0);
    }

    //Number of token of each owner
    //The address have to exist
    function balanceOf(address _owner) public view returns (uint) {
        require(_owner != address(0), 'Non-existent address');
        return _ownerTokenCount[_owner].current();
    }

    function ownerOf(uint _tokenId) public view returns (address) {
        address _owner = _tokenOwner[_tokenId];
        require(_owner != address(0), 'Non-existent address');
        return _owner;
    }
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), 'Can not transfert to a zero address');
        require(ownerOf(_tokenId) == _from, "You're not the owner of this token");

        _ownerTokenCount[_from].decrement();
        _ownerTokenCount[_to].increment();

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override public {
        require(isApprovedOrOwner(msg.sender, _tokenId),"You are not owner or approved");
        _transferFrom(_from, _to, _tokenId);
    }
    
    /*function approve(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        //make sure the person approving is the owner of the tokenId
        require (msg.sender == owner, "you are not the current owner");
        //we can't approve sending tokens from the owner to the owner
        require(_to != owner, "You can not approve to the current owner");
        
        _tokenApprovals[_tokenId] = _to;

        emit Approval(owner, _to, _tokenId);

    }*/
    function _exists (uint256 _tokenId) internal view returns (bool) {
        return _tokenOwner[_tokenId] != address(0);
    }
    //find out what address is approve for the tokenId
    function getApproved (uint256 tokenId) public view returns (address) {
        require(_exists(tokenId), "token does not exist");
        return _tokenApprovals[tokenId];
    }
    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "token does not exist");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender);
    }
    
}