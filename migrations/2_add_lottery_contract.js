var Lottery = artifacts.require("Lottery");
// the winning guess, to be put the owner
var winningGuess = 40000;

module.exports = function (deployer) {
  deployer.deploy(Lottery, winningGuess);
}
