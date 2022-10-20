// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {

    //Array to store the NFTs
    string [] public kryptoBirdz;
    //mappring to track if the kryptoBird is already created
    //we use a string because we are minting by the picture
    //e.g data location instead of the tokenid
    mapping (string => bool) _kryptoBirdzExists;

    constructor () ERC721Connector ('KryptoBird', 'KBIDZ') {

    }
    function mint (string memory _kryptoBird) public {
        //uint _id = kryptoBirdz.push(_kryptoBird);
        //This method do not work anymore since version 6.0
        //because the push method only add an element
        //but do not update the lenght
        require(!_kryptoBirdzExists[_kryptoBird],
        "Sorry! This kryptoBird already exist");
        kryptoBirdz.push(_kryptoBird);
        uint _id = kryptoBirdz.length -1;
        _kryptoBirdzExists[_kryptoBird] = true;

        _mint(msg.sender, _id);
    }

}