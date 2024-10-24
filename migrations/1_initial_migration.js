// 1_initial_migration.js

const Migrations = artifacts.require("Migrations");

module.exports = function (deployer, network) {
  deployer.deploy(Migrations);
  network.deploy(Migrations);
};
