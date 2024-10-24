// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Lottery {
    // Struct to store user information
    struct User {
        address userAddress;
        uint tokensBought;
        uint[] guess;
    }

    // A list of the users
    mapping (address => User) public users;
    address[] public userAddresses;

    address public owner;
    bytes32 winningGuessSha3;

    // Constructor function
    constructor(uint _winningGuess) {
        // By default the owner of the contract is accounts[0] to set the owner change truffle.js
        owner = msg.sender;
        winningGuessSha3 = keccak256(abi.encodePacked(_winningGuess));
    }

    // Returns the number of tokens purchased by an account
    function userTokens(address _user) view public returns (uint) {
        return users[_user].tokensBought;
    }

    // Returns the guess made by user so far
    function userGuesses(address _user) view public returns(uint[] memory) {
        return users[_user].guess;
    }

    // Returns the winning guess
    function winningGuess() view public returns(bytes32) {
        return winningGuessSha3;
    }

    // To add a new user to the contract to make guesses
    function makeUser() public {
        users[msg.sender].userAddress = msg.sender;
        users[msg.sender].tokensBought = 0;
        userAddresses.push(msg.sender);
    }

    // Function to add tokens to the user that calls the contract
    // The money held in contract is sent using a payable modifier function
    // Money can be released using selfdestruct(address)
    function addTokens() public payable {
        uint present = 0;
        uint tokensToAdd = msg.value / (10**18);

        for (uint i = 0; i < userAddresses.length; i++) {
            if (userAddresses[i] == msg.sender) {
                present = 1;
                break;
            }
        }

        // Adding tokens if the user is present in the userAddresses array
        if (present == 1) {
            users[msg.sender].tokensBought += tokensToAdd;
        }
    }

    // To add user guesses
    function makeGuess(uint _userGuess) public {
        require(_userGuess < 1000000 && users[msg.sender].tokensBought > 0, "Invalid guess or insufficient tokens");
        users[msg.sender].guess.push(_userGuess);
        users[msg.sender].tokensBought--;
    }

    // Doesn't allow anyone to buy anymore tokens
    function closeGame() view public returns(address) {
        // Can only be called by the owner of the contract
        require(owner == msg.sender, "Only the owner can close the game");
        address winner = winnerAddress();
        return winner;
    }

    // Returns the address of the winner once the game is closed
    function winnerAddress() view public returns(address) {
        for (uint i = 0; i < userAddresses.length; i++) {
            User memory user = users[userAddresses[i]];

            for (uint j = 0; j < user.guess.length; j++) {
                if (keccak256(abi.encodePacked(user.guess[j])) == winningGuessSha3) {
                    return user.userAddress;
                }
            }
        }
        // The owner wins if there are no winning guesses
        return owner;
    }

    // Sends 50% of the ETH in contract to the winner and rest of it to the owner
    function getPrice() public returns (uint) {
        require(owner == msg.sender, "Only the owner can get the prize");
        address winner = winnerAddress();

        if (winner == owner) {
            (bool sent, ) = owner.call{value: address(this).balance}("");
            require(sent, "Failed to send Ether to owner");
        } else {
            // Returns half the balance of the contract
            uint toTransfer = address(this).balance / 2;

            // Transfer 50% to the winner
            (bool sent, ) = winner.call{value: toTransfer}("");
            require(sent, "Failed to send Ether to winner");

            // Transfer the rest of the balance to the owner of the contract
            (bool ownerSent, ) = owner.call{value: address(this).balance}("");
            require(ownerSent, "Failed to send Ether to owner");
        }
        return address(this).balance;
    }

    // Allow contract to receive Ether directly
    receive() external payable {}
}
