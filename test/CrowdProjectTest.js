const CrowdProject = artifacts.require("./CrowdProject.sol");
const CrowdProjectFactory = artifacts.require("./CrowdProjectFactory.sol");

const EH = require("./exceptionsHelpers.js");
const BN = web3.utils.BN;
const toWei = web3.utils.toWei;

contract("CrowdProjectFactory", async accounts => {

  const _owner = accounts[0]
  const _admin1 = accounts[1]
  const _admin2 = accounts[2]
  const _contributer1 = accounts[3]
  const _contributer2 = accounts[4]
  const _contributer3 = accounts[5]
  const _contributer4 = accounts[6]

  let _name = "Project 1 Test"
  let _discription = "Crowd Funding and Sourcing Test"
  let instance
  describe("Factory Design", async() => {

    it("is properly assigned to admin", async () => {
      let factory = await CrowdProjectFactory.new({from: accounts[9]})
      let tx = await factory.createProject(_name,2,_discription, {from: _admin1, value: toWei("0.1", "ether")});

      instance = await CrowdProject.at(tx.logs[0].args.contractAddress)

      let PAdmin = await instance.getAdmin()

      assert.equal(PAdmin,_admin1, "Caller of factory.createProject is not the Project admin");
    });
    it("is properly assigned to admin", async () => {
      let factory = await CrowdProjectFactory.new({from: accounts[9]})
      let tx = await factory.createProject(_name,2,_discription, {from: _admin1, value: toWei("0.1", "ether")});

      instance = await CrowdProject.at(tx.logs[0].args.contractAddress)

      let PAdmin = await instance.getAdmin()

      assert.equal(PAdmin,_admin1, "Caller of factory.createProject is not the Project admin");
    });



  });


});
