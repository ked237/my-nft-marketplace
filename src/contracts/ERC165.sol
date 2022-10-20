// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC165.sol';

contract ERC165 is IERC165 {

    mapping (bytes4 => bool) private _supportedInterfaces;

    constructor() {
        _registerInterace(bytes4(keccak256('supportsinteface(bytes4 interfaceId)')));
    }

    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return _supportedInterfaces[interfaceID];
    }

    function _registerInterace(bytes4 interfaceId) public {
        require(interfaceId != 0xffffffff, 'ERC165: Invalid Interface');
        _supportedInterfaces[interfaceId] = true;
    }

}