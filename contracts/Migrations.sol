// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Digrations {
    address public owner;
    uint public last_completed_migration;

    // Constructor initializes the contract owner to the deployer (msg.sender)
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict certain functions to only the owner of the contract
    modifier restricted() {
        require(msg.sender == owner, "This function is restricted to the contract's owner");
        _;
    }

    // Function to set the completed migration (only owner can call this)
    function setCompleted(uint completed) public restricted {
        last_completed_migration = completed;
    }

    // Function to upgrade the contract to a new address
    function upgrade(address new_address) public restricted {
        // Correctly initializing a new instance of the Migrations contract
        Digrations upgraded = Digrations(new_address);
        upgraded.setCompleted(last_completed_migration);
    }
}
