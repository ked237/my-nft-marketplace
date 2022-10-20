// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable, ERC721 {

    uint256[] private _allTokens;

    //Mapping of tokenId in _alltokens
    mapping(uint256 => uint256) private _allTokensIndex;

    //Mapping of owner to list all owner tokens
    mapping(address => uint256[]) private _ownedTokens;

    //Mapping from tokenId to index of the the token's owner list
    mapping(uint => uint) private _ownedTokensIndex;

    constructor() {
        _registerInterace(bytes4(keccak256('totalSupply(bytes4)')^
        keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));
    } 
   
    //return the total supply of the _allTokens array
    function totalSupply () public override view returns (uint) {
        return _allTokens.length;
    }
    
    //the argument for the override modifier is optional but we can it for precision
    //In solidity, we override as we marked the same function virtual
    //we use the special key super that allows us to grab the mint function

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
    //add token to the total supply with the push method
    //was previously _addTokensToTotalSupply
    //now we can add to the index to
        _addTokensToAllTokenEnumeration(tokenId);
    //add token to the rightfull owner
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
    //set the token index of the tokenId to the length since we want it's position
    //the array
        _allTokensIndex[tokenId] = _allTokens.length;  
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
    //set the token index of the tokenId owned by an address to the length of all token
    //owned by that address since we want it's position in that mapping
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
    //add the address and the tokenId to the _ownedToken mapping
        _ownedTokens[to].push(tokenId);    
    }
    //Helpers function

    function tokenByIndex(uint256 index) public override view returns (uint) {
    //make sure that the index is not out of bound so that the code
    //do not break
        require (index < totalSupply(), 'global index is out of bounds');
        return _allTokens[index];
    }
    function tokenOfOwnerByIndex(address owner, uint256 index) public override view returns (uint) {
        require (index < balanceOf(owner), 'owner index is out of bounds');
        return _ownedTokens[owner][index];
    }

}