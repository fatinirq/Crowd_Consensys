const CrowdProjectFactory = artifacts.require("CrowdProjectFactory");

module.exports = function(deployer) {
  deployer.deploy(CrowdProjectFactory);
};
