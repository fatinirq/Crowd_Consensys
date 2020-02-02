const CrowdMember = artifacts.require("CrowdMember");

module.exports = function(deployer) {
  deployer.deploy(CrowdMember);
};
