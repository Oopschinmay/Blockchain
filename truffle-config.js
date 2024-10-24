// Allows us to use ES6 in our migrations and tests.
require('babel-register')

// by default the owner of the contract is account[0]
// to set an owner set the 'from' option with the address of the new owner

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1', // Localhost (default: none)
      port: 7545,        // Standard Ethereum port (default: none)
      network_id: '*',   // Any network (default: none)
    }
  },

  // Add the compilers section to specify the Solidity version
  compilers: {
    solc: {
      version: "0.8.22",  // Specify the exact version of Solidity to use
      settings: {         // Additional compiler settings (optional)
        optimizer: {
          enabled: true,  // Enable optimizer for gas savings
          runs: 200       // Optimize for how many times you intend to run the code
        }
      }
    }
  }
}
